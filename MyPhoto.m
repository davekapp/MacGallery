//
//  MyPhoto.m
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyPhoto.h"
#import <Quartz/Quartz.h>

@interface MyPhoto ()
    
@property (retain) NSImage *thumbnail;
- (void) generateUniqueID;

@end

@implementation MyPhoto

// Core Data properties are generated at run-time, not compile-time, so use @dynamic instead of @synthesize
@dynamic filePath;
@dynamic uniqueID;
@dynamic orderIndex;
@dynamic album;

// normal properties
@synthesize thumbnail;

+ (id) photoInDefaultContext {
    
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
    MyPhoto *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                     inManagedObjectContext:context];
    newItem.filePath = nil;
    
    return newItem;
}

- (NSImage*) largeThumbnail {
    
    // the large thumbnail is used by the list view
    
    if( self.thumbnail ) return self.thumbnail;
    
    NSSize size = NSMakeSize(250, 250);
    CFStringRef path = (CFStringRef)self.filePath;
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    
    // use QuickLook to generate a thumbnail of the image
    CGImageRef thumb = QLThumbnailImageCreate(NULL, url, size, nil);
    NSImage *image = [[NSImage alloc] initWithCGImage:thumb size:size];
    self.thumbnail = image;
    
    CFRelease(url);
    CFRelease(thumb);
    [image release];
    
    return image;
}

#pragma mark -
#pragma mark Core Data Methods

- (void) awakeFromInsert {
    // called when the object is first created
    [self generateUniqueID];
}

#pragma mark -
#pragma mark IKIBrowserItem protocol methods

- (NSString*) imageTitle {
    
    NSString *fullFileName = self.filePath.lastPathComponent;
    return [fullFileName stringByDeletingPathExtension];
}

- (NSString*) imageUID {
    
    // return uniqueID if it exists - otherwise make then return
    NSString *uniqueID = self.uniqueID;
    if( uniqueID ) return uniqueID;
    
    [self generateUniqueID];
    return self.uniqueID;
}

- (NSString*) imageRepresentationType {
    return IKImageBrowserPathRepresentationType;
}

- (id) imageRepresentation {
    return self.filePath;
}

#pragma mark -
#pragma mark private methods

- (void) generateUniqueID {
    
    NSString *uniqueID = self.uniqueID;
    if( uniqueID != nil ) return;
    self.uniqueID = [[NSProcessInfo processInfo] globallyUniqueString];
}

- (void) dealloc {
    
    // core data properties are automatically managed, only release synthesized properties
    self.thumbnail = nil;
    [super dealloc];
}
    
@end
    
