//
//  AddBookViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "AddBookViewController.h"
#import "Book+CreatingDeleting.h"
#import "Constants.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"

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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
        self.ratingLabel.text=[NSString stringWithFormat:@"%d/10",self.ratingValue];
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



- (IBAction)addAndShare:(UIButton *)sender {
    if ([self.titleTextField.text length]){
        
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"Add & Share" withLabel:@"Add & Share Button Pressed" withValue:[NSNumber numberWithInt:15]];
        
        [self addBook];
        [self share];
    }
}

- (IBAction)addBook:(UIBarButtonItem*)sender 
{
    if ([self.titleTextField.text length]){
        
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"Add" withLabel:@"Add Button Pressed" withValue:[NSNumber numberWithInt:14]];
        
        [self addBook];
    }
}

- (void)addBook
{
    self.textToShare = [NSString stringWithFormat:@"finished reading \"%@\"",self.titleTextField.text];
    
    
    if (!self.ratingSwitch.isOn){
        self.ratingValue=0;
    }
    else {
        self.textToShare = [NSString stringWithFormat:@"%@ and rated it: %d/10",self.textToShare,self.ratingValue];
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
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"Added Book" withLabel:@"Success" withValue:[NSNumber numberWithInt:16]];
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
        self.addAndShareView.hidden = YES;
        CGRect oldButtonFrame = self.addButton.frame;
        self.addButton.frame = CGRectMake(130, oldButtonFrame.origin.y, oldButtonFrame.size.width, oldButtonFrame.size.height);
        
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
        
    }
    else {
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
    [self setAddButton:nil];
    [self setAddAndShareView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

#pragma mark - facebook sharing

- (void)publishStory
{
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"publishStory" withLabel:@"Proper sharing - add book" withValue:[NSNumber numberWithInt:18]];
    
    NSString *message = self.textToShare;
    
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    NSString *alertText;
                                    if (error) {
                                        
                                        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"Share Problem" withLabel:@"problem with facebook - add book" withValue:[NSNumber numberWithInt:19]];
                                        
                                        alertText = [NSString stringWithFormat:
                                                     @"There was a problem with Facebook connection"];
                                    } else {
                                        
                                        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"Share Succeded" withLabel:@"published to facebook - add book" withValue:[NSNumber numberWithInt:20]];
                                        
                                        alertText = [NSString stringWithFormat:
                                                     @"Posted to Facebook"];
                                    }
                                    // Show the result in an alert
                                    [[[UIAlertView alloc] initWithTitle:@""
                                                                message:alertText
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil]
                                     show];
                                    
                                }];
    
    
    
}

- (void)share
{
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Book share" withAction:@"Share" withLabel:@"Share started - add book" withValue:[NSNumber numberWithInt:17]];
    
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPermissions:[NSArray arrayWithObject:@"publish_actions"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (!error) {
                // If permissions granted, publish the story
                [self publishStory];
            }
        }];
    }
    else {
        if ([FBSession.activeSession.permissions
             indexOfObject:@"publish_actions"] == NSNotFound) {
            // No permissions found in session, ask for it
            
            [FBSession.activeSession reauthorizeWithPermissions:[NSArray arrayWithObject:@"publish_actions"] behavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, NSError *error) {
                if (!error) {
                    // If permissions granted, publish the story
                    [self publishStory];
                }
            }];
            
        } else {
            // If permissions present, publish the story
            [self publishStory];
        }
    }
}

@end
