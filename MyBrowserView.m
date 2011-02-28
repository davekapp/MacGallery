//
//  MyBrowserView.m
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyBrowserView.h"

#import "MyPhoto.h"
#import "MyAlbum.h"
#import "MyEditorView.h"
#import "MyMainWindow.h"

// private methods
@interface MyBrowserView (Private)

- (void) setupImageBrowser;
- (void) updateSortOrderForObjects: (NSArray*)items;

@end


@implementation MyBrowserView

// synthesizin' time!
@synthesize mainWindowController;
@synthesize imageBrowser;
@synthesize albumsTable;
@synthesize albumsArrayController;
@synthesize imagesArrayController;
@synthesize imagesSortDescriptors;
@synthesize thumbnailScale;

// methodin' time (not a real verb, but whatever)

- (void) loadView {
    
    [super loadView];
    
    NSSortDescriptor *sort;
    sort = [NSSortDescriptor sortDescriptorWithKey:@"orderIndex" ascending:YES];
    
    self.imagesSortDescriptors = [NSArray arrayWithObject:sort];
    self.albumsTable.delegate = self;
    [self setupImageBrowser];
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification {
    
    NSTableView *table  = [notification object];
    NSInteger selection = table.selectedRow;
    NSArray *albums     = [self.albumsArrayController arrangedObjects];

    MyAlbum *album = [albums objectAtIndex:selection];
    [[NSApp delegate] setValue:album forKey:@"selectedAlbum"];
}

#pragma mark -
#pragma mark Image Browser

- (void) imageBrowser: (IKImageBrowserView*)browser cellWasDoubleClickedAtIndex: (NSUInteger)index {
    
    NSArray *visiblePhotos = [self.imagesArrayController arrangedObjects];
    MyPhoto *photo = [visiblePhotos objectAtIndex:index];
    
    MyMainWindow *window = self.mainWindowController;
    id editor = [window viewControllerForName:@"MyEditorView"];
    
    if ([editor isKindOfClass:[MyEditorView class]]) {
        [(MyEditorView*)editor editPhoto:photo];
    }
    else {
        NSLog(@"Editor is not a MyEditorView, it is a %@", NSStringFromClass([editor class]));
    }
}

- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender {
    
    IKImageBrowserView *browser = self.imageBrowser;
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSUInteger dropIndex = [browser indexAtLocationOfDroppedItem];
    NSArray *photos      = self.imagesArrayController.arrangedObjects;
    
    // indexes to place photoos
    NSMutableSet *indexSet = [NSMutableSet indexSet];
    [indexSet addIndex:dropIndex];
    
    // the move might be within the view
    if ([sender draggingSource] == browser) {
        NSIndexSet *selected = browser.selectionIndexes;
        NSArray *draggingItems = [photos objectsAtIndexes:selected];
        NSMutableArray *reorderedItems = [photos mutableCopy];
        
        [reorderedItems removeObjectsInArray:draggingItems];
        
        NSUInteger newDropIndex = dropIndex;
        NSUInteger index = 0;
        NSUInteger firstIndex = selected.firstIndex;
        
        for(index = firstIndex; index != NSNotFound; index = [selected indexGreaterThanIndex:index]) {
            if (index < dropIndex) {
                newDropIndex -= 1;
            }
            else {
                break;
            }
        } // end for
        
        NSRange dropRange = NSMakeRange(newDropIndex, draggingItems.count);
        NSIndexSet dropIndexes = [NSIndexSet indexSetWithIndexesInRange:dropRange];
        
        [reorderedItems insertObjects:draggingItems atIndexes:dropIndexes];
        [self updateSortOrderForObjects:reorderedItems];
        [reorderedItems release];
        return YES;
    } // end if
    // source is not the browser
    
    NSMutableArray *newItems = [NSMutableArray array];
    MyAlbum *album = [[NSApp delegate] valueForKey:@"selectedAlbum"];
    
    // get a list of the new files
    NSArray *fileNames = [pboard propertyListForType:NSFilenamesPboardType];
    NSInteger indexCount = 0;
    if (fileNames.count < 1) {
        return NO; // bad drag, zero items
    }
    
    for( NSString *file in fileNames ) {
        
        MyPhoto *newPhoto = [MyPhoto photoInDefaultContext];
        newPhoto.filePath = file;
        [newItems addObject:newPhoto];
        [indexSet addIndex:dropIndex+indexCount];
        newPhoto.album = album;
        indexCount++;
    }

    NSMutableArray *array = [photos mutableCopy];
    [array insertObjects:newItems atIndexes:indexSet];
    [self updateSortOrderForObjects:array];
    [array release];
    return YES;
} // end of method

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

#pragma mark -
#pragma mark Private

- (void) setupImageBrowser {
    
    IKImageBrowserView *browser         = self.imageBrowser;
    browser.draggingDestinationDelegate = self;
    browser.delegate        = self;
    browser.cellsStyleMask  = (IKCellsStyleShadowed | IKCellsStyleTitled );
    browser.zoomValue       = 0.55;
    
    // base attributes
    NSFont *font            = [NSFont systemFontOfSize:11];
    NSColor *textColor      = [NSColor colorWithCalibratedWhite:0.8 alpha:1.0];
    NSColor *textColorAlt   = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
    NSColor *background     = [NSColor colorWithCalibratedWhite:0.2 alpha:1.0];

    // text attributes
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    [textAttr setObject:textColor forKey:NSForegroundColorAttributeName];
    [textAttr setObject:font forKey:NSFontAttributeName];
    
    // selected text attributes
    NSMutableDictionary *altTextAttr = [NSMutableDictionary dictionary];
    [altTextAttr setObject:textColorAlt forKey:NSForegroundColorAttributeName];
    [altTextAttr setObject:font forKey:NSFontAttributeName];
    
    // set the text attributes to be used
    [browser setValue:textAttr    forKey:IKImageBrowserCellsTitleAttributesKey];
    [browser setValue:altTextAttr forKey:IKImageBrowserCellsHighlightedTitleAttributesKey];
    [browser setValue:background  forKey:IKImageBrowserBackgroundColorKey];
} // end method

- (void) updateSortOrderForObjects:(NSArray *)items {
    
    NSMutableArray *arrangeItems = [NSMutableArray array];
    NSInteger orderIndex = 0;
    
    for( MyPhoto *photo in items ) {
        // don't handle an item more than once
        if ( [arrangedItems containsObject:photo] ) continue;
        photo.orderIndex = [NSNumber numberWithInteger:orderIndex];
        [arrangedItems addObject:photo];
        orderIndex++;
    }
    
    // reload the array controller
    [self.imagesArrayController rearrangeObjects];
}

- (void) dealloc {
    self.imageBrowser = nil;
    self.albumsTable = nil;
    self.albumsArrayController = nil;
    self.imagesArrayController = nil;
    self.imagesSortDescriptors = nil;
    
    [super dealloc];
}

@end
