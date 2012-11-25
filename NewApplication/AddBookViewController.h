//
//  AddBookViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@class AddBookViewController;
@protocol AddBookViewControllerDelegate
- (UIManagedDocument *)delegatesDataBase;
- (void)reloadAfterChanges;
- (void)finishedUsingDatabase;
@end

@interface AddBookViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIManagedDocument *dataBase;
@property BOOL finishedBooks;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *ratingPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingMinusButton;

@property (weak, nonatomic) IBOutlet UILabel *staticLabelRating;
@property (weak, nonatomic) IBOutlet UISwitch *ratingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *addAndShareView;

@property (nonatomic, strong) id<AddBookViewControllerDelegate> delegate;

@end
