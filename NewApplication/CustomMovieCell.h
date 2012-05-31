//
//  CustomMovieCell.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/27/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomMovieCell;
@protocol customMovieCellDelegate 

- (void)editCell:(CustomMovieCell*)sender;
- (void)moveSelectedMovieToWatched:(CustomMovieCell*)sender;
@end

@interface CustomMovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *titleMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelRating;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAddedLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *goToEditButton;
@property (weak, nonatomic) IBOutlet UIButton *watchedButton;
@property (nonatomic,strong) id<customMovieCellDelegate> delegate;


@end
