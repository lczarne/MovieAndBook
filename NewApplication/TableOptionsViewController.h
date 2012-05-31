//
//  TableOptionsViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/29/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableOptionsViewController;
@protocol TableOptionsViewControllerDelegate

- (void)changeTableSortTypeTo:(int)type sender:(TableOptionsViewController*)sender;

@end

@interface TableOptionsViewController : UIViewController
@property (nonatomic,strong) NSString* instructionText;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (nonatomic) int selectedSortType;
@property (nonatomic,strong) id <TableOptionsViewControllerDelegate> delegate;

- (void)setSegmentedControlOptions:(NSArray *)options;


@end
