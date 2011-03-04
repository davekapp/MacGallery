//
//  MyAlbum.h
//  Gallery
//
//  Created by David Kapp on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyAlbum : NSManagedObject

@property (retain) NSString *title;
@property (retain) NSSet *photos;

+ (id) defaultAlbum;
+ (id) albumInDefaultContext;

@end
