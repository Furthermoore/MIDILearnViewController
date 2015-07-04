//
//  MIDILearnViewController.h
//  MidiLearner
//
//  Created by Dan Moore on 7/4/15.
//  Copyright (c) 2015 FurtherMoore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIDILearnViewControllerDelegate <NSObject>

- (void)didSenseControllerNumber:(int)number;

@end

@interface MIDILearnViewController : UIViewController

@property (nonatomic, weak) id<MIDILearnViewControllerDelegate>delegate;

@end
