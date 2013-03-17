//
//  AppDelegate.h
//  Streamy
//
//  Created by David Rauch on 2/22/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet INAppStoreWindow *window;
@property (weak) IBOutlet NSView *toolbar;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) NSMutableArray* entries;
@property (weak) IBOutlet NSPopover *popover;
@property (weak) IBOutlet NSButton *usernameButton;

- (IBAction)showUserPopup:(id)sender;
- (IBAction)usernameChanged:(id)sender;

@end
