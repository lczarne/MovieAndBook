//
//  CustomNavigationBar.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/22/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "CustomNavigationBar.h"


@implementation CustomNavigationBar

@synthesize navigationBarImage=_navigationBarImage;

- (UIImage *)navigationBarImage
{
    if (_navigationBarImage){
        return _navigationBarImage;
    }
    else{
        return [UIImage imageNamed: @"bar5.png"];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) drawRect:(CGRect)rect 
{
    UIImage *image = [UIImage imageNamed: @"bar5.png"];
   // [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeOverlay alpha:1];
}

@end
