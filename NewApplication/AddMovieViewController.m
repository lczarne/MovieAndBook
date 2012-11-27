//
//  AddMovieViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "AddMovieViewController.h"
#import "Movie+CreatingDeleting.h"
#import "Constants.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"

@interface AddMovieViewController()
@property (nonatomic) int ratingValue;

@end

@implementation AddMovieViewController
@synthesize delegate;
@synthesize dataBase=_dataBase;
@synthesize watchedMovies=_watchedMovies;

@synthesize titleField=_titleField;
@synthesize infoField=_infoField;
@synthesize staticLabelRating=_staticLabelRating;
@synthesize ratingSwitch=_ratingSwitch;
@synthesize ratingView=_ratingView;
@synthesize ratingLabel=_ratingLabel;
@synthesize ratingMinusButton=_ratingMinusButton;
@synthesize ratingPlusButton=_ratingPlusButton;
@synthesize saveMovieButton=_saveMovieButton;

@synthesize ratingValue=_ratingValue;


- (IBAction)goBack
{
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






- (void)addMovie
{
    self.textToShare = [NSString stringWithFormat:@"watched \"%@\"",self.titleField.text];
    
    
    if (!self.ratingSwitch.isOn){
        self.ratingValue=0;
    }
    else {
        self.textToShare = [NSString stringWithFormat:@"%@ and rated it: %d/10",self.textToShare,self.ratingValue];
    }
    
    [Movie movieWithTitle:self.titleField.text
                   Rating:[NSNumber numberWithInt:self.ratingValue]
                     Info:self.infoField.text
                  Watched:self.watchedMovies
   inManagedObjectContext:self.dataBase.managedObjectContext];
    
    [self.delegate reloadAfterChanges];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Movie was Added."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    self.titleField.text=@"";
    self.infoField.text=@"";
    
    self.ratingSwitch.on=NO;
    self.ratingView.hidden=YES;
    self.ratingValue=0;
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"Added Movie" withLabel:@"Success" withValue:[NSNumber numberWithInt:6]];
    
}

- (IBAction)addAndShare:(id)sender {
    
    
    if ([self.titleField.text length]){
        
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"Add & Share" withLabel:@"Add & Share Button Pressed" withValue:[NSNumber numberWithInt:5]];
        
        [self addMovie];
        [self share];
    }
    
}



- (IBAction)addMovie:(UIBarButtonItem*)sender 
{
    
    if ([self.titleField.text length]){
        
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"Add" withLabel:@"Add Button Pressed" withValue:[NSNumber numberWithInt:4]];
        
        [self addMovie];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger insertDelta = string.length - range.length;
    
    int maxLength = 100;
    switch (textField.tag) {
        case 0:
            maxLength = k_MAX_TITLE_LENGTH;
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

#pragma mark - View lifecycle

-(void)viewDidLoad
{


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.watchedMovies){
        self.ratingSwitch.hidden=YES;
        self.staticLabelRating.hidden=YES;
        self.addAndShareView.hidden = YES;
        CGRect oldButtonFrame = self.addButton.frame;
        self.addButton.frame = CGRectMake(130, oldButtonFrame.origin.y, oldButtonFrame.size.width, oldButtonFrame.size.height);
        
    }
    self.ratingSwitch.on=NO;
    self.ratingView.hidden=YES;
    self.titleField.delegate=self;
    self.infoField.delegate=self;
    
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

- (void)viewDidUnload {
    [self setTitleField:nil];
    [self setInfoField:nil];
    [self setStaticLabelRating:nil];
    [self setRatingSwitch:nil];
    [self setRatingView:nil];
    [self setRatingLabel:nil];
    [self setRatingMinusButton:nil];
    [self setRatingPlusButton:nil];
    [self setSaveMovieButton:nil];
    [self setAddButton:nil];
    [self setAddAndShareButton:nil];
    [self setAddAndShareView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - facebook sharing

- (void)publishStory
{
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"publishStory" withLabel:@"Proper sharing - add movie" withValue:[NSNumber numberWithInt:8]];
    
    NSString *message = self.textToShare;
    
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    NSString *alertText;
                                    if (error) {
                                        
                                        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"Share Problem" withLabel:@"problem with facebook - add movie" withValue:[NSNumber numberWithInt:9]];
                                        
                                        alertText = [NSString stringWithFormat:
                                                     @"There was a problem with Facebook connection"];
                                    } else {
                                        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"Share Succeded" withLabel:@"published to facebook - add movie" withValue:[NSNumber numberWithInt:10]];
                                        
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
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Movie share" withAction:@"Share" withLabel:@"Share started - add movie" withValue:[NSNumber numberWithInt:7]];
    
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
