//
//  AddMovieViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "AddMovieViewController.h"
#import "Movie+CreatingDeleting.h"

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



- (IBAction)addMovie:(UIBarButtonItem*)sender 
{
    if ([self.titleField.text length]){
        if (!self.ratingSwitch.isOn){
            self.ratingValue=0;
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
    if (!self.watchedMovies){
        self.ratingSwitch.hidden=YES;
        self.staticLabelRating.hidden=YES;
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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
