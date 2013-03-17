//
//  DRYoutubeExtractor.m
//  Subscriptions
//
//  Created by David Rauch on 3/17/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import "DRYoutubeExtractor.h"

@implementation DRYoutubeExtractor

+ (id)sharedDRYoutubeExtractor
{
    static dispatch_once_t onceToken;
    static id sharedDRYoutubeExtractor = nil;
    
    dispatch_once(&onceToken, ^{
        sharedDRYoutubeExtractor = [[[self class] alloc] init];
    });
    
    return sharedDRYoutubeExtractor;
}

- (void)extractVideo:(NSURL *)youtubeURL inQuality:(DRYoutubeQuality)quality withCompletionBlock:(DRYoutubeExtractorCompletionBlock)completionBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURLRequest* youtubeRequest = [NSURLRequest requestWithURL:youtubeURL];
		NSData* data = nil;
		NSURLResponse* response = nil;
		NSError* error = nil;
		
		data = [NSURLConnection sendSynchronousRequest:youtubeRequest returningResponse:&response error:&error];

		if(error) {
			NSLog(@"Error: %@", error);
			return;
		}
	
		//Define relevant formats
		NSArray* possibleItags = @[@"18", @"22", @"37"];
		NSMutableDictionary* streamMap = [NSMutableDictionary dictionaryWithCapacity:3];
	
		//Define Regular Expressions
		NSRegularExpression* fmtExp = [[NSRegularExpression alloc] initWithPattern:@"\"url_encoded_fmt_stream_map\":\\s*\"([^\"]+)\"" options:0 error:&error];
		NSRegularExpression* itagExp = [[NSRegularExpression alloc] initWithPattern:@"itag=(\\d{0,2})" options:0 error:&error];
		NSRegularExpression* sigExp = [[NSRegularExpression alloc] initWithPattern:@"sig=([A-Z0-9]*\\.[A-Z0-9]*)" options:0 error:&error];
		NSRegularExpression* urlExp = [[NSRegularExpression alloc] initWithPattern:@"^url=" options:0 error:&error];
	
		NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
		//Get fmt_stream_map
		NSArray* fmtMatches = [fmtExp matchesInString:html options:0 range:NSMakeRange(0, [html length])];
		NSString* fmtStreamsString = [html substringWithRange:[fmtMatches[0] range]];
		NSArray* fmtStreams = [fmtStreamsString componentsSeparatedByString:@","];
	
		//Iterate over streams
		for(NSString* stream in fmtStreams) {
		
			//Get itag
			NSArray* itagMatches = [itagExp matchesInString:stream options:0 range:NSMakeRange(0, [stream length])];
			NSString* itagString = [stream substringWithRange:[itagMatches[0] range]];
			NSString* itag = [itagString componentsSeparatedByString:@"="][1];
		
			//Check if itag is relevant
			if([possibleItags containsObject:itag]) {
		
				//Get signature
				NSArray* sigMatches = [sigExp matchesInString:stream options:0 range:NSMakeRange(0, [stream length])];
				NSString* sigString = [stream substringWithRange:[sigMatches[0] range]];
				NSString* sig = [sigString componentsSeparatedByString:@"="][1];
		
				//Get url
				NSString* decodedStream = [stream stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				NSArray* decodedStreamComponents = [decodedStream componentsSeparatedByString:@"\\u0026"];
		
				for(NSString* decodedStreamComponent in decodedStreamComponents) {
					NSArray* urlMatches = [urlExp matchesInString:decodedStreamComponent options:0 range:NSMakeRange(0, [decodedStreamComponent length])];
					if([urlMatches count] > 0) {
						NSString* videoURL = [NSString stringWithFormat:@"%@&signature=%@", [decodedStreamComponent substringFromIndex:4], sig];
						[streamMap setValue:videoURL forKey:itag];
					}
			
				}
		
			}
		
		}
		
		NSURL* videoURL = nil;
		
		//Find best stream
		for(NSInteger i = quality; i >= 0; i--) {
			NSString* aVideoURL = [streamMap valueForKey:possibleItags[i]];
			if(aVideoURL) {
				videoURL = [NSURL URLWithString:aVideoURL];
				break;
			}
		}
		
		//Call callback
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			completionBlock(videoURL, error);
		}];
		
	});
	
}

@end
