//
//  ViewController.m
//  MidiLearner
//
//  Created by Dan Moore on 7/4/15.
//  Copyright (c) 2015 FurtherMoore. All rights reserved.
//

#import "ViewController.h"
#import "MIDILearnViewController.h"

@interface ViewController()<MIDILearnViewControllerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *learnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [learnButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [learnButton setTitle:@"LEARN" forState:UIControlStateNormal];
    learnButton.titleLabel.font = [UIFont systemFontOfSize:75.0];
    learnButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    learnButton.layer.borderWidth = 3.0;
    learnButton.layer.cornerRadius = 30.0;
    [learnButton addTarget:self action:@selector(presentMidiLearnVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:learnButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:learnButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:learnButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

}

- (void)presentMidiLearnVC
{

    [self presentViewController:[[MIDILearnViewController alloc] init] animated:YES completion:nil];
}

-(void)didSenseControllerNumber:(int)number
{
    NSLog(@"sensing controller number %d", number); // I'll simply print the # ;)
}

@end
