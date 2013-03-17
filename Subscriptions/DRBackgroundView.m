//
//  DRBackgroundView.m
//  Streamy
//
//  Created by David Rauch on 2/23/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import "DRBackgroundView.h"

@implementation DRBackgroundView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:49./255. green:54./255. blue:61./255. alpha:1] set];
	NSRectFill(dirtyRect);
}

@end
