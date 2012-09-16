//
//  TableOptionsViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/29/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "TableOptionsViewController.h"

@implementation TableOptionsViewController
@synthesize instructionText = _instructionText;
@synthesize instructionLabel = _instructionLabel;
@synthesize selectedSortType=_selectedSortType;
@synthesize delegate=_delegate;
#define SEGMENT_WIDTH 85
#define SEGMENT_HEIGHT 30
#define SEGMENT_CONTROL_Y 330


- (void)setSegmentedControlOptions:(NSArray *)options
{
    //self.sortTypeOptions=nil;
   // NSArray *itemArray = [NSArray arrayWithObjects: @"One", @"Two", @"Three", nil];
    UISegmentedControl *control= [[UISegmentedControl alloc] initWithItems:options];
    CGFloat size= SEGMENT_WIDTH * [options count];
    
    CGFloat startX= (self.view.frame.size.width/2) - (size/2);
    
    control.frame = CGRectMake(startX, SEGMENT_CONTROL_Y, size, SEGMENT_HEIGHT);
    control.segmentedControlStyle = UISegmentedControlStyleBezeled;
    control.tintColor= [UIColor blackColor];
    control.selectedSegmentIndex = self.selectedSortType;
    [self.view addSubview:control];
    [control addTarget:self 
                action:@selector(pickOption:) 
      forControlEvents:UIControlEventValueChanged];

    
    
    /*
    self.sortTypeOptions = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.sortTypeOptions.frame = CGRectMake(35, 450, 250, 50);
	self.sortTypeOptions.segmentedControlStyle = UISegmentedControlStylePlain;
	self.sortTypeOptions.selectedSegmentIndex = 1;
    self.sortTypeOptions.hidden=NO;
    [self.view addSubview:self.sortTypeOptions];
    [self.sortTypeOptions setNeedsDisplay];
    */
    
}

- (void)pickOption:(UISegmentedControl*)sender
{
    //NSLog(@"selectedIndex: %d",sender.selectedSegmentIndex);
    [self.delegate changeTableSortTypeTo:sender.selectedSegmentIndex 
                                  sender:self];
    
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    self.instructionLabel.text=self.instructionText;
}

- (void)viewDidUnload {
    [self setInstructionLabel:nil];
    [super viewDidUnload];
}
@end
