//
//  MovieDetailsViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController()
@property (nonatomic) int ratingValue;
@end

@implementation MovieDetailsViewController
@synthesize movie=_movie;
@synthesize titleField = _titleField;
@synthesize infoField = _infoField;
@synthesize staticLabelRating=_staticLabelRating;
@synthesize ratingSwitch=_ratingSwitch;
@synthesize ratingView=_ratingView;
@synthesize ratingLabel=_ratingLabel;
@synthesize decreaseRatingButton=_decreaseRatingButton;
@synthesize increaseRatingButton=_increaseRatingButton;
@synthesize saveButton=_saveButton;
@synthesize deleteButton=_deleteButton;

@synthesize delegate=_delegate;

@synthesize ratingValue=_ratingValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setRatingValue:(int)ratingValue
{
    if (ratingValue != _ratingValue) {
        _ratingValue=ratingValue;
        self.ratingLabel.text=[NSString stringWithFormat:@"%d",self.ratingValue];
    }
}
- (void)showRating
{
    if (self.ratingValue==0) {
        self.ratingValue=5;
    }
    self.ratingView.hidden=NO;
}

- (void)hideRating
{
    self.ratingView.hidden=YES;
}


- (IBAction)editRating:(UISwitch*)sender {
    if (self.ratingSwitch.isOn){
        [self showRating];
    }
    else{
        [self hideRating];
    }
}


- (IBAction)increaseRating:(UIButton*)sender {
    if (self.ratingValue<10) {
        self.ratingValue++;
    }
}

- (IBAction)decreaseRating:(UIButton*)sender {
    if (self.ratingValue>1) {
        self.ratingValue--;
    }
}


- (IBAction)saveChanges:(UIButton*)sender {
    if (([self.titleField.text length])) {
        self.movie.title=self.titleField.text;
        self.movie.info=self.infoField.text;
        if (self.ratingSwitch.isOn){
            self.movie.rating= [NSNumber numberWithInt:self.ratingValue];
        }
        else{
            self.movie.rating= [NSNumber numberWithInt:0];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Saved."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self.delegate reloadAfterChanges];
    }
}


- (IBAction)deleteMovie:(UIButton*)sender {
    [self.delegate deleteMovie:self.movie sender:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Movie was deleted."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"didLoad %@",self.movie);
    self.titleField.text=self.movie.title;
    self.infoField.text= self.movie.info;
    NSLog(@"watched %d",self.movie.watched.intValue);
    if (self.movie.watched.boolValue==YES){
        self.ratingValue=self.movie.rating.intValue;
        if (self.ratingValue==0) {
            self.ratingSwitch.on=NO;
            [self hideRating];
        }
        else{
            self.ratingSwitch.on=YES;
            [self showRating];
        }
    }
    else{
        self.ratingSwitch.on=NO;
        self.ratingSwitch.hidden=YES;
        self.staticLabelRating.hidden=YES;
        self.ratingView.hidden=YES;
    }
    
    
    self.titleField.delegate=self;
    self.infoField.delegate=self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate finishedUsingDatabase];
}

- (void)viewDidUnload
{
    [self setStaticLabelRating:nil];
    [self setRatingSwitch:nil];
    [self setRatingView:nil];
    [self setRatingLabel:nil];
    [self setDecreaseRatingButton:nil];
    [self setIncreaseRatingButton:nil];
    [self setSaveButton:nil];
    [self setDeleteButton:nil];
    [self setTitleField:nil];
    [self setInfoField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
