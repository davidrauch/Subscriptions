//
//  DRTableCellView.m
//  Streamy
//
//  Created by David Rauch on 2/22/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import "DRTableCellView.h"
#import "ImageCache.h"
#import "NSImage+MGCropExtensions.h"
#import "DRYoutubeExtractor.h"
#import <ScriptingBridge/ScriptingBridge.h>

@implementation DRTableCellView

- (void)setObjectValue:(id)objectValue {
	[super setObjectValue:objectValue];
	
	if(objectValue) {
		[[ImageCache sharedImageCache] imageForURL:[objectValue valueForKey:@"img"]		callback:^(NSImage* image) {
			NSImage* scaledImage = [image imageScaledToFitSize:NSMakeSize(320.0, 1000.0)];
			NSImage* croppedImage = [scaledImage imageCroppedToFitSize:NSMakeSize(320.0, 180.0)];
			[self.playButton setImage:croppedImage];
		}];
	} else {
		[self.playButton setImage:nil];
	}
}

- (void)drawRect:(NSRect)dirtyRect {
	self.bounds = NSMakeRect(0.0, 0.0, 320.0, 180.0);
}

- (void)playVideo:(id)sender {
	
	DRYoutubeQuality quality = [[[NSUserDefaults standardUserDefaults] valueForKey:@"resolution"] intValue];
	
	[[DRYoutubeExtractor sharedDRYoutubeExtractor] extractVideo:[self.objectValue valueForKey:@"url"] inQuality:quality withCompletionBlock:^(NSURL* videoURL, NSError* error) {
		if(!error) {
			id qtApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.QuickTimePlayerX"];
			[qtApp activate];
			if ([qtApp isRunning]) {
				[qtApp openURL:videoURL];
			}
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
	}];
}

@end
