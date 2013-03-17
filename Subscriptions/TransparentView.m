//
//  TransparentView.m
//  Streamy
//
//  Created by David Rauch on 2/23/13.
//  Copyright (c) 2013 David Rauch. All rights reserved.
//

#import "TransparentView.h"

@implementation TransparentView

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
    [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.5]
	 set];
	[[NSGraphicsContext currentContext]
	 setCompositingOperation:NSCompositePlusDarker];
	[[NSBezierPath bezierPathWithRect:dirtyRect] fill];
}

- (BOOL)isOpaque {
	return NO;
}

@end
