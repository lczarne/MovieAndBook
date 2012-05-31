//
//  AccessoryView.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/16/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "AccessoryView.h"

@implementation AccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    

    CGContextBeginPath(context);
   // CGContextSetLineWidth(context, 2.0f);
    
    /*
    
    CGContextMoveToPoint(context, midPoint.x-5, midPoint.y-5);
    CGContextAddLineToPoint(context,midPoint.x,midPoint.y+3);
    CGContextAddLineToPoint(context,midPoint.x+5,midPoint.y-5);
    
    */
    CGContextMoveToPoint(context, midPoint.x-5, midPoint.y-5);
    CGContextAddLineToPoint(context,midPoint.x+3,midPoint.y);
    CGContextAddLineToPoint(context,midPoint.x-5,midPoint.y+5);
    
   // CGContextClosePath(context);
 //   CGContextSetStrokeColorWithColor(context, [[UIColor  whiteColor] CGColor]);
  //  CGContextStrokePath(context);
    
    [[UIColor whiteColor] setStroke];
    [[UIColor blackColor] setFill];
    
    
    //CGContextStrokePath(context);
    CGContextFillPath(context);    
    
}

@end
