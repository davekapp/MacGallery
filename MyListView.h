//
//  MyListView.h
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyMainWindow;

@interface MyListView : NSViewController

@property (assign) MyMainWindow *mainWindowController;
@property (retain) IBOutlet NSTableView *imagesTable;
@property (retain) IBOutlet NSArrayController *imagesArrayController;

- (IBAction) tableViewItemDoubleClicked:(id)sender;

@end
