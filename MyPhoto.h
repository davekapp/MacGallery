//
//  MyPhoto.h
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyAlbum;

@interface MyPhoto : NSManagedObject

// attributes as properties
@property (retain) NSString *filePath;
@property (retain) NSString *uniqueID;
@property (retain) NSNumber *orderIndex;

// relationships as properties
@property (retain) MyAlbum *album;

// properties separate from the model
@property (readonly) NSImage *largeThumbnail;

// finally, some methods
+ (id) photoInDefaultContext;

@end
