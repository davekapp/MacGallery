//
//  MyEditorView.m
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyEditorView.h"
#import "MyPhoto.h"
#import "MyMainWindow.h"

@implementation MyEditorView

@synthesize mainWindowController;
@synthesize imageView;

- (void) loadView {
    [super loadView];
    [self.imageView setImageWithURL:nil];
}

- (void) editPhoto:(MyPhoto*)photo {
    if (self.view == nil) {
        [self loadView];
    }
    
    NSURL *url = [NSURL fileURLWithPath:photo.filePath];
    
    [self.imageView setImageWithURL:url];
    [self.mainWindowController activateViewController:self];
}

- (void) dealloc {
    self.imageView = nil;
    [super dealloc];
}

@end
