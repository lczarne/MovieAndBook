//
//  BookDetailsViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@class BookDetailsViewController;
@protocol BookDetailViewDelegate
- (void)deleteBook:(Book*)book sender:(BookDetailsViewController*) sender;
- (void)reloadAfterChanges;
- (void)finishedUsingDatabase;
@end

@interface BookDetailsViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) Book *book;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *authorField;
@property (weak, nonatomic) IBOutlet UITextField *infoField;
@property (weak, nonatomic) IBOutlet UISwitch *ratingSwitch;
@property (weak, nonatomic) IBOutlet UIButton *ratingMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingPlusButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelRating;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *ratingEditionView;

@property (strong , nonatomic) id<BookDetailViewDelegate> delegate;

@end
