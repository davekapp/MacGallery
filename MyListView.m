//
//  MyListView.m
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyListView.h"
#import "MyMainWindow.h"
#import "MyPhoto.h"
#import "MyEditorView.h"

@implementation MyListView

@synthesize mainWindowController;
@synthesize imagesTable;
@synthesize imagesArrayController;

- (void) loadView {
    [super loadView];
    
    self.imagesTable.target = self;
    self.imagesTable.doubleAction = @selector(tableViewItemDoubleClicked:);
}

- (IBAction) tableViewItemDoubleClicked:(id)sender {
    
    NSInteger row = self.imagesTable.clickedRow;
    NSArray *visiblePhotos = [self.imagesArrayController arrangedObjects];
    MyPhoto *photo = [visiblePhotos objectAtIndex:row];
    
    MyMainWindow *window = self.mainWindowController;
    id editor = [window viewControllerForName:@"MyEditorView"];
    if ([editor isKindOfClass:[MyEditorView class]]) {
        [(MyEditorView*)editor editPhoto:photo];
    }
    else {
        NSLog(@"Tried to open an editor from tableViewItemDoubleClicked but got object of class %@",
              NSStringFromClass([editor class]));
    }
}

- (void) dealloc {
    
    self.imagesTable = nil;
    self.imagesArrayController = nil;
    [super dealloc];
}
    
@end
