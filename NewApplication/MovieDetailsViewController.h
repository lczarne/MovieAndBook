//
//  MovieDetailsViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@class MovieDetailsViewController;
@protocol MovieDetailViewDelegate
-(void)deleteMovie:(Movie*)book sender:(MovieDetailsViewController*) sender;
-(void)reloadAfterChanges;
@end

@interface MovieDetailsViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic,strong) Movie *movie;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *infoField;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelRating;
@property (weak, nonatomic) IBOutlet UISwitch *ratingSwitch;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIButton *decreaseRatingButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseRatingButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic,strong) id<MovieDetailViewDelegate> delegate;

@end
