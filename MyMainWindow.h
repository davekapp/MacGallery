//
//  MyMainWindow.h
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface MyMainWindow : NSWindowController

// IBOutlets
@property (retain) IBOutlet NSSegmentedControl *viewSelectionControl;

// view management properties (sounds like real estate, but it's not)
@property (retain) NSMutableDictionary *viewControllers;
@property (assign) NSViewController *currentViewController;
@property (copy) NSArray *controllerNamesByIndex;

// view management methods
- (IBAction) viewSelectionDidChange: (id)sender;
- (void) activateViewController: (NSViewController*)controller;
- (NSViewController*) viewControllerForName: (NSString*)name;

@end
