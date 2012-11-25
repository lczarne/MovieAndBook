//
//  CustomSpecialCell.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/22/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "CustomSpecialCell.h"

@implementation CustomSpecialCell
@synthesize basicView = _basicView;
@synthesize detailsView = _detailsView;
@synthesize mainTitle = _mainTitle;
@synthesize authorLabel=_authorLabel;
@synthesize staticLabelRating = _staticLabelRating;
@synthesize ratingLabel=_ratingLabel;
@synthesize dateAddedLabel=_dateAddedLabel;
@synthesize finishedButton = _finishedButton;
@synthesize delegate=_delegate;
@synthesize titleTextView = _titleTextView;
@synthesize descriptionTextView = _descriptionTextView;

- (IBAction)moveBookToFinished:(UIButton*)sender {
    if (!self.finishedButton.selected){
        self.finishedButton.selected=YES;
        [self.delegate moveSelectedBookToFinished:self];
    }
    else{
        self.finishedButton.selected=NO;
        [self.delegate moveSelectedBookToFinished:self];
    }
}
- (IBAction)shareBook:(id)sender {
    [self.delegate shareFinishedBook];
}

- (IBAction)goToEditBook:(UIButton*)sender {
    [self.delegate editCell:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
