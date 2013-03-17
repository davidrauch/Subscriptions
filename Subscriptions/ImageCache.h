//
//  ImageCache.h
//  Streamy
//
//  Created by David Rauch on 2/22/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallbackBlock)(NSImage* image);

@interface ImageCache : NSObject {
	NSMutableDictionary* data;
}

+ (ImageCache*)sharedImageCache;

- (void)imageForURL:(NSURL*)imageURL callback:(CallbackBlock)callback;

@end
