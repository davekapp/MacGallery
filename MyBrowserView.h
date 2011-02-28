//
//  MyBrowserView.h
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface MyBrowserView : NSViewController <NSTableViewDelegate>

// parent window property
@property (assign) MyMainWindow *mainWindowController;

// IBOutlet properties

@property (retain) IBOutlet IKImageBrowserView *imageBrowser;
@property (retain) IBOutlet NSTableView *albumsTable;
@property (retain) IBOutlet NSArrayController *albumsArrayController;
@property (retain) IBOutlet NSArrayController *imagesArrayController;

// assorted other properties

@property (retain) NSArray *imagesSortDescriptors;
@property (assign) CGFloat thumbnailScale;

@end
