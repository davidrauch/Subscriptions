//
//  DRTableCellView.h
//  Streamy
//
//  Created by David Rauch on 2/22/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRTableCellView : NSTableCellView

@property (weak) IBOutlet NSImageView* imageView;
@property (weak) IBOutlet NSButton* playButton;

- (IBAction)playVideo:(id)sender;

@end
