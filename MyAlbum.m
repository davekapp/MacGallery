//
//  MyAlbum.m
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAlbum.h"


@implementation MyAlbum

// remember, use @dynamic for Core Data properties, not @synthesize
@dynamic title;
@dynamic photos;

+ (id) albumInDefaultContext {
    
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
    MyAlbum *newItem;
    newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Album"
                                            inManagedObjectContext:context];
    
    return newItem;
}

+ (id) defaultAlbum {
    
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Album"
                                              inManagedObjectContext:context];

    // create a fetch request to find the 'Default' album
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = entity;
    fetch.predicate = [NSPredicate predicateWithFormat:@"title == 'Default'"];
    
    // run fetch and make sure it succeeded
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetch error:&error];
    [fetch release];
    if (error) {
        NSLog(@"Error trying to do fetch: %@", error);
        return nil;
    }
    
    // create the album if it doesn't exist
    MyAlbum *album = nil;
    if (results.count > 0) {
        album = [results objectAtIndex:0];
    }
    else {
        album = [self albumInDefaultContext];
        album.title = @"Default";
    }
    
    return album;
}

// used by list view
- (NSImage*) image {
    return [NSImage imageNamed:NSImageNameFolder];
}
    
@end
