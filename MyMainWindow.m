//
//  MyMainWindow.m
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMainWindow.h"

// static stuff

static const NSInteger BrowserViewIndex = 0;
static const NSInteger EditorViewIndex  = 1;
static const NSInteger ListViewIndex    = 2;

// names for the views

static NSString* const MyBrowserViewName = @"MyBrowserView";
static NSString* const MyEditorViewName  = @"MyEditorView";
static NSString* const MyListViewName    = @"MyListView";


@implementation MyMainWindow

// synthesizers (live in concert!)

@synthesize viewSelectionControl;
@synthesize viewControllers;
@synthesize currentViewController;
@synthesize controllerNamesByIndex;

// method implementations

- (void) loadWindow {
	
	[super loadWindow];
	self.viewControllers = [NSMutableDictionary dictionary];
	
	// match indexes to their names
	NSMutableArray *names = [NSMutableArray array];
	[names insertObject:MyBrowserViewName atIndex:BrowserViewIndex];
	[names insertObject:MyEditorViewName  atIndex:EditorViewIndex];
	[names insertObject:MyListViewName    atIndex:ListViewIndex];
	
	// start in browser mode
	NSViewController *initial = [self viewControllerForName:MyBrowserViewName];
	[self activateViewController:initial];
}

- (IBAction) viewSelectionDidChange: (id)sender {
	
	// find the requested view controller
	NSInteger selection      = [sender selectedSegment];
	NSArray *names           = self.controllerNamesByIndex;
	NSString *controllerName = [names objectAtIndex:selection];
	
	// load the controller
	NSViewController *controller = [self viewControllerForName:controllerName];
	[self activateViewController:controller];
}

- (void) activateViewController: (NSViewController *)controller {
	
	NSArray *names          = self.controllerNamesByIndex;
	NSInteger segment       = self.viewSelectionControl.selectedSegment;
	
	NSString *targetName    = [controller className];
	NSInteger targetIndex   = [names indexOfObject:targetName];
    
    // update segmented control
    if (segment != targetIndex) {
        [self.viewSelectionControl setSelectedSegment:targetIndex];
    }
    
    // remove the current view
    [self.currentViewController.view removeFromSuperview];
    
    // now set the new view controller up
    self.currentViewController = controller;
    [[self.window contentView] addSubview:controller.view];
    
    // adjust for window margins
    NSWindow *window = self.window;
    CGFloat padding = [window contentBorderThicknessForEdge:NSMinYEdge];
    NSRect frame = [window.contentView frame];
    frame.size.height -= padding;
    frame.origin.y += padding;
    controller.view.frame = frame;
}

- (NSViewController*) viewControllerForName:(NSString *)name {
    
    // see if the view already exists
    NSMutableDictionary *allControllers = self.viewControllers;
    NSViewController *controller = [allControllers objectForKey:name];
    if (controller) return controller;
    
    // create a new instance of the view
    Class controllerClass = NSClassFromString(name);
    controller = [[controllerClass alloc] initWithNibName:name bundle:nil];
    [allControllers setObject:controller forKey:name];
    
    // use key-value coding to avoid compiler warnings
    [controller setValue:self forKey:@"mainWindowController"];
    return [controller autorelease];
}

- (void) dealloc {
    
    self.viewSelectionControl = nil;
    self.viewControllers = nil;
    self.controllerNamesByIndex = nil;
    
    [super dealloc];
}

@end
