//
//  CustomMovieCell.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/27/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "CustomMovieCell.h"

@implementation CustomMovieCell
@synthesize basicView;
@synthesize detailsView;
@synthesize titleMainLabel;
@synthesize titleDetailsLabel;
@synthesize infoLabel;
@synthesize goToEditButton;
@synthesize watchedButton;
@synthesize staticLabelRating;
@synthesize ratingLabel;
@synthesize dateAddedLabel;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)shareWatchedMovie:(id)sender {
    [self.delegate shareWatchedMovie];
}

- (IBAction)moveBookToFinished:(UIButton*)sender {
    [self.delegate moveSelectedMovieToWatched:self];
}
- (IBAction)goToEditBook:(UIButton*)sender {
    [self.delegate editCell:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
