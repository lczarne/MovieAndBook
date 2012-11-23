//
//  AddMovieViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@class AddMovieViewController;
@protocol AddMovieViewControllerDelegate
- (UIManagedDocument *)delegatesDataBase;
- (void)reloadAfterChanges;
- (void)finishedUsingDatabase;
@end

@interface AddMovieViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate, FBLoginViewDelegate>


@property (nonatomic,strong) UIManagedDocument *dataBase;
@property BOOL watchedMovies;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *infoField;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelRating;
@property (weak, nonatomic) IBOutlet UISwitch *ratingSwitch;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIButton *ratingMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *saveMovieButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *addAndShareButton;
@property (weak, nonatomic) IBOutlet UIView *addAndShareView;

@property (nonatomic, strong) id<AddMovieViewControllerDelegate> delegate;


@end
