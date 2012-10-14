//
//  BookDetailsViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "Constants.h"

@interface BookDetailsViewController()
@property (nonatomic) int ratingValue;
@end


@implementation BookDetailsViewController
@synthesize book=_book;
@synthesize titleField = _titleField;
@synthesize authorField = _authorField;
@synthesize infoField = _infoField;
@synthesize ratingSwitch = _ratingSwitch;
@synthesize ratingMinusButton = _ratingMinusButton;
@synthesize ratingPlusButton = _ratingPlusButton;
@synthesize ratingLabel = _ratingLabel;
@synthesize staticLabelRating = _staticLabelRating;
@synthesize saveButton = _saveButton;
@synthesize deleteButton = _deleteButton;
@synthesize ratingEditionView = _ratingEditionView;
@synthesize delegate=_delegate;

@synthesize ratingValue=_ratingValue;

- (IBAction)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRatingValue:(int)ratingValue
{
    if (ratingValue != _ratingValue) {
        _ratingValue=ratingValue;
        self.ratingLabel.text=[NSString stringWithFormat:@"%d/10",self.ratingValue];
    }
}
- (void)showRating
{
    if (self.ratingValue==0) {
        self.ratingValue=5;
    }
    self.ratingEditionView.hidden=NO;
}

- (void)hideRating
{
    self.ratingEditionView.hidden=YES;
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
    
    if (([self.titleField.text length] && [self.authorField.text length])) {
        self.book.title=self.titleField.text;
        self.book.author=self.authorField.text;
        self.book.info=self.infoField.text;
        if (self.ratingSwitch.isOn){
            self.book.rating= [NSNumber numberWithInt:self.ratingValue];
        }
        else{
            self.book.rating= [NSNumber numberWithInt:0];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Saved."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self.delegate reloadAfterChanges];
    }

}

- (IBAction)deleteBook:(UIBarButtonItem*)sender {
    [self.delegate deleteBook:self.book sender:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Book was deleted."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle


-(void)viewWillAppear:(BOOL)animated
{
    self.titleField.text=self.book.title;
    self.authorField.text=self.book.author;
    self.infoField.text= self.book.info;
    if (self.book.finished.boolValue==YES){
        self.ratingValue=self.book.rating.intValue;
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
        self.ratingEditionView.hidden=YES;
    }
    
    
    self.titleField.delegate=self;
    self.authorField.delegate=self;
    self.infoField.delegate=self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate finishedUsingDatabase];
}

- (void)viewDidUnload
{

    [self setTitleField:nil];
    [self setAuthorField:nil];
    [self setInfoField:nil];
    [self setRatingSwitch:nil];
    [self setRatingMinusButton:nil];
    [self setRatingPlusButton:nil];
    [self setRatingLabel:nil];
    [self setSaveButton:nil];
    [self setDeleteButton:nil];
    [self setRatingEditionView:nil];
    [self setStaticLabelRating:nil];
 
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger insertDelta = string.length - range.length;
    
    int maxLength = 100;
    switch (textField.tag) {
        case 0:
            maxLength = k_MAX_TITLE_LENGTH;
            break;
        case 1:
            maxLength = k_MAX_AUTHOR_LENGTH;
            break;
        case 2:
            maxLength = k_MAX_DESCRIPTION_LENGTH;
            break;
    }
    
    if (textField.text.length + insertDelta > maxLength)
    {
        return NO; // the new string would be longer than MAX_LENGTH
    }
    else {
        return YES;
    }
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
