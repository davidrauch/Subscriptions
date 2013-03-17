//
//  ImageCache.m
//  Streamy
//
//  Created by David Rauch on 2/22/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

+ (id)sharedImageCache {
    static dispatch_once_t onceToken;
    static id sharedImageCache = nil;
    
    dispatch_once(&onceToken, ^{
        sharedImageCache = [[[self class] alloc] init];
    });
    
    return sharedImageCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        data = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)imageForURL:(NSURL*)imageURL callback:(CallbackBlock)callback {
	NSImage* image = [data valueForKey:[imageURL absoluteString]];
	if(image) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
            callback(image);
        }];
	} else {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
			NSImage* imageFromBundle = [[NSImage alloc] initWithData:imageData];
			[data setValue:imageFromBundle forKey:[imageURL absoluteString]];
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				callback(imageFromBundle);
			}];
		});
	}
}

@end
