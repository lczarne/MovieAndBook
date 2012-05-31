//
//  CustomSpecialCell.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/22/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSpecialCell;
@protocol customSpecialCellDelegate 

- (void)editCell:(CustomSpecialCell*)sender;
- (void)moveSelectedBookToFinished:(CustomSpecialCell*)sender;
@end

@interface CustomSpecialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLabelRating;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAddedLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (nonatomic, strong) id<customSpecialCellDelegate> delegate;

@end
