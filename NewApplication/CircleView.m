//
//  CircleView.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/11/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

@synthesize circelColor=_circelColor;

- (UIColor*)circelColor
{
    if (!_circelColor) {
        _circelColor=[UIColor whiteColor];
    }
    return _circelColor;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init code
    }
    return self;
}

- (void) drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [self.circelColor setFill];
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    //CGContextStrokePath(context);
    CGContextFillPath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width;  
    if (size>self.bounds.size.height) size=self.bounds.size.height;
    size /=2;
    size *=0.95;
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
}

@end
