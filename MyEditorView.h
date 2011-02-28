//
//  MyEditorView.h
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class MyMainWindow;
@class MyPhoto;

@interface MyEditorView : NSViewController

@property (assign) MyMainWindow *mainWindowController;
@property (retain) IBOutlet IKImageView *imageView;

- (void) editPhoto: (MyPhoto*)photo;

@end
