//
//  AddBookViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "AddBookViewController.h"
#import "Book+CreatingDeleting.h"

@interface AddBookViewController()
@property (nonatomic) int ratingValue;
@end

@implementation AddBookViewController

@synthesize ratingValue=_ratingValue;
@synthesize dataBase=_dataBase;
@synthesize finishedBooks=_finishedBooks;
@synthesize saveButton=_saveButton;
@synthesize titleTextField=_titleTextField;
@synthesize authorTextField=_authorTextField;
@synthesize descriptionTextField=_descriptionTextField;
@synthesize ratingPlusButton = _ratingPlusButton;
@synthesize ratingMinusButton = _ratingMinusButton;
@synthesize staticLabelRating = _staticLabelRating;
@synthesize ratingSwitch = _ratingSwitch;
@synthesize ratingLabel = _ratingLabel;
@synthesize ratingView = _ratingView;
@synthesize delegate = _delegate;

- (int)ratingValue
{
    if (!_ratingValue) {
        _ratingValue=0;
    }
    return _ratingValue;
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

- (IBAction)showRatingOption:(UISwitch*)sender {
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




- (IBAction)addBook:(UIBarButtonItem*)sender 
{
    if ([self.titleTextField.text length] && [self.authorTextField.text length]){
        if (!self.ratingSwitch.isOn){
            self.ratingValue=0;
        }
        [Book bookWithTitle:self.titleTextField.text 
                     Author:self.authorTextField.text 
                     Rating:[NSNumber numberWithInt:self.ratingValue] 
                       Info:self.descriptionTextField.text 
                   Finished:self.finishedBooks 
     inManagedObjectContext:self.dataBase.managedObjectContext];
        
        [self.delegate reloadAfterChanges];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Book was Added."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        self.titleTextField.text=@"";
        self.authorTextField.text=@"";
        self.descriptionTextField.text=@"";
        
        self.ratingSwitch.on=NO;
        self.ratingView.hidden=YES;
        self.ratingValue=0;
        
        
    }
    
}


- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.dataBase.fileURL path]]) {
        [self.dataBase saveToURL:self.dataBase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        }];
    } else if (self.dataBase.documentState ==UIDocumentStateClosed){
        [self.dataBase openWithCompletionHandler:^(BOOL suucess){
        }];
    } 
}

- (void)setDataBase:(UIManagedDocument *)dataBase
{
    if (_dataBase!=dataBase) {
        _dataBase=dataBase;
        [self useDocument];
    }
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.finishedBooks){
        self.ratingSwitch.hidden=YES;
        self.staticLabelRating.hidden=YES;
    }
    self.ratingSwitch.on=NO;
    self.ratingView.hidden=YES;
    self.titleTextField.delegate=self;
    self.authorTextField.delegate=self;
    self.descriptionTextField.delegate=self;
    
    if (self.delegate) {
        self.dataBase = [self.delegate delegatesDataBase];
    }
    else {
        if (!self.dataBase) {
            NSURL *url= [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDirectory] lastObject];
            url = [url URLByAppendingPathComponent:@"MovieBooksDatabase"];
            self.dataBase = [[UIManagedDocument alloc] initWithFileURL:url];
        }
    }    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.delegate) {
        [self.dataBase closeWithCompletionHandler:^(BOOL suucess){
        }];
        [self.delegate finishedUsingDatabase];
    }
}

- (void)viewDidUnload
{
    
    [self setTitleTextField:nil];
    [self setAuthorTextField:nil];
    [self setDescriptionTextField:nil];
    [self setSaveButton:nil];
    [self setRatingSwitch:nil];
    [self setRatingLabel:nil];
    [self setRatingView:nil];
    [self setRatingPlusButton:nil];
    [self setRatingMinusButton:nil];
    [self setStaticLabelRating:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
