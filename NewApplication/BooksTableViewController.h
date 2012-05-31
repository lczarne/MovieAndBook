//
//  BooksTableViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "CustomSpecialCell.h"
#import "BookDetailsViewController.h"
#import "TableOptionsViewController.h"

@interface BooksTableViewController : CoreDataTableViewController <customSpecialCellDelegate,BookDetailViewDelegate, TableOptionsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,strong) UIManagedDocument *dataBase;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingDataIndicator;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property BOOL showFinishedBooks;
@property BOOL usingDatabase;

- (void)setTitleLabelText:(NSString *)titleText;
@end
