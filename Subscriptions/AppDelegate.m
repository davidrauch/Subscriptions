//
//  AppDelegate.m
//  Streamy
//
//  Created by David Rauch on 2/22/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import "AppDelegate.h"
#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "ImageCache.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_entries = [NSMutableArray arrayWithCapacity:25];
	
	// Create window
	_window.titleBarHeight = 36.0;
	[_window.titleBarView addSubview:_toolbar];
	
	[self _loadVideos];
	
	if(![[NSUserDefaults standardUserDefaults] valueForKey:@"resolution"]) {
		[[NSUserDefaults standardUserDefaults] setValue:@0 forKey:@"resolution"];
	}
	
	if(![[NSUserDefaults standardUserDefaults] valueForKey:@"username"]) {
		[_popover showRelativeToRect:[_usernameButton bounds] ofView:_usernameButton preferredEdge:NSMaxYEdge];
	}
}

- (void)_loadVideos {
	[_entries removeAllObjects];
	
	// Load Videos
	// Create a success block to be called when the async request completes
	TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
		// If TBXML found a root node, process element and iterate all children
		if (tbxmlDocument.rootXMLElement) {
			TBXMLElement* root = tbxmlDocument.rootXMLElement;
			
			// Parse entries
			TBXMLElement* xmlEntry = [TBXML childElementNamed:@"entry" parentElement:root];
			while(xmlEntry != nil) {
				NSMutableDictionary* entry = [NSMutableDictionary dictionary];
				
				// Get Title
				TBXMLElement* xmlTitle = [TBXML childElementNamed:@"title" parentElement:xmlEntry];
				[entry setValue:[NSString stringWithUTF8String:xmlTitle->text] forKey:@"title"];
				
				// Get Code
				TBXMLElement* xmlURL = [TBXML childElementNamed:@"link" parentElement:xmlEntry];
				NSString* url = [TBXML valueOfAttributeNamed:@"href" forElement:xmlURL];
				while([url rangeOfString:@"http://www.youtube.com/watch?v="].location == NSNotFound && xmlURL != nil) {
					xmlURL = [TBXML nextSiblingNamed:@"link" searchFromElement:xmlURL];
					url = [TBXML valueOfAttributeNamed:@"href" forElement:xmlURL];
				}
				
				NSString* videoId = [[[[url componentsSeparatedByString:@"&amp"] objectAtIndex:0] componentsSeparatedByString:@"watch?v="] objectAtIndex:1];
				[entry setValue:videoId forKey:@"id"];
				[entry setValue:[NSURL URLWithString:[NSString stringWithFormat:@"http://youtube.com/watch?v=%@", videoId]] forKey:@"url"];
				[entry setValue:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.ytimg.com/vi/%@/hqdefault.jpg", videoId]] forKey:@"img"];
				
				// Add entry
				[_entries addObject:entry];
				
				//Preload image
				[[ImageCache sharedImageCache] imageForURL:[entry valueForKey:@"img"] callback:^(NSImage* image){}];
				
				xmlEntry = [TBXML nextSiblingNamed:@"entry" searchFromElement:xmlEntry];
			}
			
			[_tableView reloadData];
		}
	};
	
	// Create a failure block that gets called if something goes wrong
	TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
		NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
	};
	
	// Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
	NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
	
	TBXML *tbxml __unused = [[TBXML alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/base/users/%@/newsubscriptionvideos", username]]
									  success:successBlock
									  failure:failureBlock];
}

#pragma mark -
#pragma mark NSTableViewDatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [_entries count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	return [_entries objectAtIndex:rowIndex];
}

- (IBAction)showUserPopup:(id)sender {
	if([_popover isShown])
	{
		[_popover close];
	}
	else{
		[_popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
	}
}

- (IBAction)usernameChanged:(id)sender {
	[self _loadVideos];
	[_popover close];
}

@end
