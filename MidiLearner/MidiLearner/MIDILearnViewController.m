//
//  MIDILearnViewController.m
//  MidiLearner
//
//  Created by Dan Moore on 7/4/15.
//  Copyright (c) 2015 FurtherMoore. All rights reserved.
//

#import "MIDILearnViewController.h"
#import <CoreMIDI/CoreMIDI.h>

void MidiLearnReadProc(const MIDIPacketList *pktlist, void *refcon, void *srcConnRefCon);

@interface MIDILearnViewController ()
{
    MIDIClientRef mclient;
}

@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation MIDILearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // subviews
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:35.0];
    [doneButton addTarget:self action:@selector(donePushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    self.resultLabel = [[UILabel alloc] init];
    [self.resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.resultLabel.text = @"Sensing for MIDI input...";
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.font = [UIFont systemFontOfSize:50.0];
    [self.view addSubview:self.resultLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(doneButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[doneButton]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[doneButton]" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.resultLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.resultLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // setup Midi client
    int k;
    ItemCount endpoints;
    CFStringRef name = NULL, cname = NULL, pname = NULL;
    CFStringEncoding defaultEncoding = CFStringGetSystemEncoding();
    MIDIPortRef mport = 0;
    MIDIEndpointRef endpoint;
    OSStatus ret;
    
    cname = CFStringCreateWithCString(NULL, "my client", defaultEncoding);
    ret = MIDIClientCreate(cname, NULL, NULL, &mclient);
    if(!ret) {
        pname = CFStringCreateWithCString(NULL, "outport", defaultEncoding);
        ret = MIDIInputPortCreate(mclient, pname, MidiLearnReadProc, (__bridge void *)(self), &mport);
        if(!ret) {
            endpoints = MIDIGetNumberOfSources();
            for(k=0; k < endpoints; k++) {
                endpoint = MIDIGetSource(k);
                MIDIPortConnectSource(mport, endpoint, NULL);
            }
        }
    }
    if(name) CFRelease(name);
    if(pname) CFRelease(pname);
    if(cname) CFRelease(cname);
}

-(void)donePushed
{
    MIDIClientDispose(mclient);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CoreMIDI callback

- (void)sensedControllerNumber:(int)ccNum
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultLabel.text = [NSString stringWithFormat:@"Sensing CC # %d", ccNum];
        [self.delegate didSenseControllerNumber:ccNum];
    });
}

void MidiLearnReadProc(const MIDIPacketList *pktlist, void *refcon, void *srcConnRefCon)
{
    MIDILearnViewController *learner = (__bridge MIDILearnViewController *)refcon;
    MIDIPacket *packet = &((MIDIPacketList *)pktlist)->packet[0];
    Byte *curpack;
    int i, j;
    
    BOOL shouldContinue = YES;
    for (i = 0; shouldContinue && i < pktlist->numPackets; i++) {
        for (j = 0; j < packet->length; j+=3) {
            curpack = packet->data+j;
            
            if ((*curpack++ | 0xB0) > 0) {
                unsigned int controllerNumber = (unsigned int)(*curpack++);
//                unsigned int controllerValue = (unsigned int)(*curpack++); // In case you'd like the 3rd Byte as well ;)
                [learner sensedControllerNumber:(int)controllerNumber];
                shouldContinue = NO;
                break;
            }
        }
        packet = MIDIPacketNext(packet);
    }
}

@end
