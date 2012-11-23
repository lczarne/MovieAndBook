//
//  MoviesTableViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "CustomMovieCell.h"
#import "MovieDetailsViewController.h"
#import "TableOptionsViewController.h"


@interface MoviesTableViewController : CoreDataTableViewController <customMovieCellDelegate,MovieDetailViewDelegate,TableOptionsViewControllerDelegate, UIActionSheetDelegate>
@property (nonatomic,strong) UIManagedDocument *dataBase;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property BOOL showWatchedMovies;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (void)setTitleLabelText:(NSString *)titleText;
@end
