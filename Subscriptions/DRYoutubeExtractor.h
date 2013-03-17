//
//  DRYoutubeExtractor.h
//  Subscriptions
//
//  Created by David Rauch on 3/17/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DRYoutubeQuality360p	= 0,
	DRYoutubeQuality720p	= 1,
	DRYoutubeQuality1080p	= 2,
} DRYoutubeQuality;

typedef void (^DRYoutubeExtractorCompletionBlock)(NSURL* videoURL, NSError* error);

@interface DRYoutubeExtractor : NSObject

+ (DRYoutubeExtractor*)sharedDRYoutubeExtractor;

- (void)extractVideo:(NSURL*)youtubeURL inQuality:(DRYoutubeQuality)quality withCompletionBlock:(DRYoutubeExtractorCompletionBlock)completionBlock;

@end