//
//  Gallery_AppDelegate.h
//  Gallery
//
//  Created by David Kapp on 2/25/11.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyMainWindow;
@class MyAlbum;

@interface Gallery_AppDelegate : NSObject 
// Using 64-bit properties (so no instance variable section needed)

// ------------------------ Properties Provided by XCode ------------------------------
@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
// ------------------------ End Properties Provided by XCode --------------------------

// Custom properties

@property (retain) MyMainWindow *mainWindowController;
@property (retain) MyAlbum *selectedAlbum;

// save method provided by XCode (how nice of it)
- (IBAction)saveAction:sender;

- (IBAction) newAlbum:(id)sender;


@end
