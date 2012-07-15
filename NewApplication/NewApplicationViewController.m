//
//  NewApplicationViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/10/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "NewApplicationViewController.h"
#import "AddBookViewController.h"
#import "AddMovieViewController.h"
#import "ChooseView.h"
#import "CircleView.h"
#import "BooksTableViewController.h"
#import "MoviesTableViewController.h"
#import "CustomNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface NewApplicationViewController()
@property (nonatomic,weak) IBOutlet ChooseView *chooseView;

@property (weak, nonatomic) IBOutlet UILabel *info;
@property (nonatomic,weak) IBOutlet CircleView *movieView;
@property (nonatomic,weak) IBOutlet CircleView *bookView;
@property (nonatomic,weak) IBOutlet CircleView *pastView;
@property (nonatomic,weak) IBOutlet CircleView *futureView;
@property (nonatomic,weak) IBOutlet CircleView *viewAllView;
@property (nonatomic,weak) IBOutlet CircleView *enterView;

@property (weak, nonatomic) IBOutlet UILabel *pastViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *futureViewLabel;

@property (nonatomic,weak) CALayer* animationLayer;
@property (nonatomic,strong) CAShapeLayer* secondChoicePathLayerA;
@property (nonatomic,strong) CAShapeLayer* secondChoicePathLayerB;
@property (nonatomic,strong) CAShapeLayer* thirdChoicePathLayerA;
@property (nonatomic,strong) CAShapeLayer* thirdChoicePathLayerB;

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property BOOL showInstructionLabel;
@property BOOL blinkInstruction;

@property BOOL movieTapped;
@property BOOL bookTapped;
@property BOOL pastTapped;
@property BOOL futureTapped;
@property BOOL viewAllTapped;
@property BOOL enterTapped;

@end

@implementation NewApplicationViewController

@synthesize chooseView= _chooseView;
@synthesize info = _info;
@synthesize animationLayer =_animationLayer;
@synthesize secondChoicePathLayerA=_secondChoicePathLayerA;
@synthesize secondChoicePathLayerB=_secondChoicePathLayerB;
@synthesize thirdChoicePathLayerA=_thirdChoicePathLayerA;
@synthesize thirdChoicePathLayerB=_thirdChoicePathLayerB;
@synthesize instructionLabel = _instructionLabel;
@synthesize showInstructionLabel=_showInstructionLabel;
@synthesize blinkInstruction= _blinkInstruction;

@synthesize movieView= _movieView;
@synthesize bookView=_bookView;
@synthesize pastView=_pastView;
@synthesize futureView=_futureView;
@synthesize viewAllView=_viewAllView;
@synthesize enterView=_enterView;
@synthesize pastViewLabel = _pastViewLabel;
@synthesize futureViewLabel = _futureViewLabel;

@synthesize movieTapped=_movieTapped;
@synthesize bookTapped=_bookTapped;
@synthesize pastTapped=_pastTapped;
@synthesize futureTapped=_futureTapped;
@synthesize viewAllTapped=_viewAllTapped;
@synthesize enterTapped=_enterTapped;



#pragma mark - Controler methods

#define OPENING_ANIMATION 0.2
#define ANIMATION_DURATION 0.3
#define HIDE_ANIMATION_DURATION 0.2
#define DEFAULT_INSTRUCTION_TEXT @"Hold one circle"

- (void)setupAnimationLayer
{
    
    CALayer* newLayer= [CALayer layer];
    self.animationLayer = newLayer;
    
    self.animationLayer.frame = self.chooseView.frame;
    [self.chooseView.layer addSublayer:self.animationLayer];
        
    [self.chooseView bringSubviewToFront:self.movieView];
    [self.chooseView bringSubviewToFront:self.bookView];
    [self.chooseView bringSubviewToFront:self.pastView];
    [self.chooseView bringSubviewToFront:self.futureView];
    [self.chooseView bringSubviewToFront:self.enterView];
    [self.chooseView bringSubviewToFront:self.viewAllView];
    
    
}

- (void)startAnimationWithPathLayerA:(CAShapeLayer*)layerA PathLayerB:(CAShapeLayer*)layerB
{
    
    if (layerA) {
        [self.animationLayer addSublayer:layerA];
        [layerA removeAllAnimations];
        CABasicAnimation *pathAnimationA= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimationA.duration= 0.5;
        pathAnimationA.fromValue= [NSNumber numberWithFloat:0.0f];
        pathAnimationA.toValue= [NSNumber numberWithFloat:1.0f];
        [layerA addAnimation:pathAnimationA forKey:@"strokeEnd"];
    }
    
    
    if (layerB) {
        [self.animationLayer addSublayer:layerB];
        [layerB removeAllAnimations];
        CABasicAnimation *pathAnimationB= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimationB.duration= 0.5;
        pathAnimationB.fromValue= [NSNumber numberWithFloat:0.0f];
        pathAnimationB.toValue= [NSNumber numberWithFloat:1.0f];
        [layerB addAnimation:pathAnimationB forKey:@"strokeEnd"];
    }
    
}

#define PATH_OPACITY 0.10f
- (void)setupSecondChoicePathLayer
{    
    [self.secondChoicePathLayerA removeAllAnimations];
    [self.secondChoicePathLayerB removeAllAnimations];
    CGPoint startingPoint= self.movieView.center;
    CGPoint pastButtonPoint= self.pastView.center;
    CGPoint futureButtonPoint= self.futureView.center;
    
    if (self.bookTapped) {
        
        startingPoint= self.bookView.center;
        
    }    
    
    
    UIBezierPath* pathA = [UIBezierPath bezierPath];
    [pathA moveToPoint:startingPoint];
    [pathA addLineToPoint:pastButtonPoint];
    
    CAShapeLayer *pathLayerA = [CAShapeLayer layer];
    pathLayerA.frame=self.animationLayer.bounds;
    pathLayerA.path = pathA.CGPath;
    pathLayerA.strokeColor = [[UIColor blackColor] CGColor];
    pathLayerA.opacity= PATH_OPACITY;
    pathLayerA.lineWidth= 20.0f;
    pathLayerA.lineCap=kCALineCapRound;
    // pathLayerA.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:4], nil];
    
    self.secondChoicePathLayerA=pathLayerA;
    
    UIBezierPath* pathB = [UIBezierPath bezierPath];
    [pathB moveToPoint:startingPoint];
    [pathB addLineToPoint:futureButtonPoint];
    
    CAShapeLayer *pathLayerB = [CAShapeLayer layer];
    pathLayerB.frame=self.animationLayer.bounds;
    pathLayerB.path = pathB.CGPath;
    pathLayerB.strokeColor = [[UIColor blackColor] CGColor];
    pathLayerB.opacity= PATH_OPACITY;
    pathLayerB.lineWidth= 20.0f;
    pathLayerB.lineCap=kCALineCapRound;
    // pathLayerB.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:4], nil];
    
    self.secondChoicePathLayerA.hidden=NO;
    self.secondChoicePathLayerB.hidden=NO;
    
    self.secondChoicePathLayerB=pathLayerB;
    
    
    
    
    [self startAnimationWithPathLayerA:self.secondChoicePathLayerA PathLayerB:self.secondChoicePathLayerB];
    
}

- (void)setupThirdChoicePathLayer
{    
    [self.thirdChoicePathLayerA removeAllAnimations];
    [self.thirdChoicePathLayerB removeAllAnimations];
    
    CGPoint startingPoint= self.pastView.center;
    CGPoint viewAllButtonPoint= self.viewAllView.center;
    CGPoint enterButtonPoint= self.enterView.center;
    
    if (self.futureTapped) {
        
        startingPoint= self.futureView.center;
        
    }    
    
    
    UIBezierPath* pathA = [UIBezierPath bezierPath];
    [pathA moveToPoint:startingPoint];
    [pathA addLineToPoint:viewAllButtonPoint];
    
    CAShapeLayer *pathLayerA = [CAShapeLayer layer];
    pathLayerA.frame=self.animationLayer.bounds;
    pathLayerA.path = pathA.CGPath;
    pathLayerA.strokeColor = [[UIColor blackColor] CGColor];
    pathLayerA.opacity= PATH_OPACITY;
    
    pathLayerA.lineWidth= 20.0f;
    pathLayerA.lineCap=kCALineCapRound;
    // pathLayerA.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:4], nil];
    
    self.thirdChoicePathLayerA=pathLayerA;
    
    UIBezierPath* pathB = [UIBezierPath bezierPath];
    [pathB moveToPoint:startingPoint];
    [pathB addLineToPoint:enterButtonPoint];
    
    CAShapeLayer *pathLayerB = [CAShapeLayer layer];
    pathLayerB.frame=self.animationLayer.bounds;
    pathLayerB.path = pathB.CGPath;
    pathLayerB.strokeColor = [[UIColor blackColor] CGColor];
    pathLayerB.opacity= PATH_OPACITY;
    
    
    pathLayerB.lineWidth= 20.0f;
    pathLayerB.lineCap=kCALineCapRound;
    //  pathLayerB.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:4], nil];
    
    self.thirdChoicePathLayerB=pathLayerB;
    
    self.thirdChoicePathLayerA.hidden=NO;
    self.thirdChoicePathLayerB.hidden=NO;
    
    
    [self startAnimationWithPathLayerA:self.thirdChoicePathLayerA PathLayerB:self.thirdChoicePathLayerB];
}

- (void)showFirstChoice
{
    self.instructionLabel.text = DEFAULT_INSTRUCTION_TEXT;
    self.showInstructionLabel = YES;
    self.movieView.transform=CGAffineTransformRotate(self.movieView.transform, -2*M_PI/5);
    self.bookView.transform=CGAffineTransformRotate(self.bookView.transform, -2*M_PI/4);
    
    [UIView animateWithDuration:OPENING_ANIMATION animations:^{
        
        self.movieView.transform=CGAffineTransformRotate(self.movieView.transform, 2*M_PI/5);
        self.bookView.transform=CGAffineTransformRotate(self.bookView.transform, 2*M_PI/4);
        
        
        self.movieView.alpha=1;
        self.bookView.alpha=1;
        self.movieView.hidden=NO;
        self.bookView.hidden=NO;
    }];
        
}

- (void)hideFirstChoice
{
    
    self.movieView.alpha=0;
    self.bookView.alpha=0;
    self.movieView.hidden=YES;
    self.bookView.hidden=YES;
}

- (void)showSecondChoice
{
    self.instructionLabel.text = @"";
    self.showInstructionLabel = YES;
    self.blinkInstruction = YES;
    
    [self setupSecondChoicePathLayer];
    
    self.pastView.transform=CGAffineTransformRotate(self.pastView.transform, -2*M_PI/5);
    self.futureView.transform=CGAffineTransformRotate(self.futureView.transform, -2*M_PI/4);
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.pastView.transform=CGAffineTransformRotate(self.pastView.transform, 2*M_PI/5);
        self.futureView.transform=CGAffineTransformRotate(self.futureView.transform, 2*M_PI/4);
        
        
        self.pastView.alpha=1;
        self.futureView.alpha=1;
        self.pastView.hidden=NO;
        self.futureView.hidden=NO;
    }];
    
}

- (void)hideSecondChoice
{
    [self.secondChoicePathLayerA removeFromSuperlayer];
    [self.secondChoicePathLayerB removeFromSuperlayer];
    
    self.movieTapped=NO;
    self.bookTapped=NO;
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        self.pastView.alpha=0;
        self.futureView.alpha=0;
    }];
    
}

- (void)hideCircleView:(CircleView*)circle withChoicePathLayer:(CAShapeLayer*)choicePathLayer
{
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        circle.alpha=0;
    }];    
    
    if (choicePathLayer) {
        [choicePathLayer removeFromSuperlayer];
    }
    
}

- (void)showCircleView:(CircleView*)circle withChoicePathLayerA:(CAShapeLayer*)choicePathLayerA PathLayerB:(CAShapeLayer*)choicePathLayerB
{
    
    circle.transform=CGAffineTransformRotate(circle.transform, -2*M_PI/5);
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        circle.transform=CGAffineTransformRotate(circle.transform, 2*M_PI/5);
        
        
        circle.alpha=1;
    }];
    
    if (choicePathLayerA) {
        [self startAnimationWithPathLayerA:choicePathLayerA PathLayerB:nil];
    }
    
    if (choicePathLayerB) {
        [self startAnimationWithPathLayerA:nil PathLayerB:choicePathLayerB];
    }
}

- (void)showThirdChoice
{
    
    [self setupThirdChoicePathLayer];
    
    self.viewAllView.transform=CGAffineTransformRotate(self.viewAllView.transform, -2*M_PI/5);
    self.enterView.transform=CGAffineTransformRotate(self.enterView.transform, -2*M_PI/4);
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.viewAllView.transform=CGAffineTransformRotate(self.viewAllView.transform, 2*M_PI/5);
        self.enterView.transform=CGAffineTransformRotate(self.enterView.transform, 2*M_PI/4);
        
        
        self.viewAllView.alpha=1;
        self.enterView.alpha=1;
        self.viewAllView.hidden=NO;
        self.enterView.hidden=NO;
    }];
}


- (void)hideThirdChoice
{
    [self.thirdChoicePathLayerA removeFromSuperlayer];
    [self.thirdChoicePathLayerB removeFromSuperlayer];
    
    self.pastTapped =NO;
    self.futureTapped =NO;
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        self.viewAllView.alpha=0;
        self.enterView.alpha=0;
    }];
}


- (void)uncheck
{
    self.instructionLabel.text = DEFAULT_INSTRUCTION_TEXT;
    self.instructionLabel.alpha = 1;
    self.showInstructionLabel = YES;
    self.blinkInstruction = NO;
    self.movieTapped =NO;
    self.bookTapped =NO;
    self.pastTapped =NO;
    self.futureTapped =NO;
    self.viewAllTapped =NO;
    self.enterTapped =NO;
    
    
    [self.secondChoicePathLayerA removeFromSuperlayer];
    [self.secondChoicePathLayerB removeFromSuperlayer];
    [self.thirdChoicePathLayerA removeFromSuperlayer];
    [self.thirdChoicePathLayerB removeFromSuperlayer];
    
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        self.pastView.alpha=0;
        self.futureView.alpha=0;
        self.viewAllView.alpha=0;
        self.enterView.alpha=0;
    }];
    
    
}


- (void)changeInstructionText
{
    if (self.showInstructionLabel){
        NSString *text=@"";
        
        if (self.enterTapped || self.viewAllTapped){
            
            NSString *prefix = self.viewAllTapped ? @"Release finger to view " : @"Release finger to enter new ";
            
            NSString *interfixA;
            
            if (self.bookTapped) {
                interfixA = self.viewAllTapped ? @"books " : @"book ";
            }
            else interfixA = self.viewAllTapped ? @"movies " : @"movie ";
            
            NSString *interfixB;
            
            if (self.bookTapped) {
                interfixB = self.pastTapped ? @"finished " : @"to read ";
            }
            else interfixB = self.pastTapped ? @"watched " : @"to see ";
            
            
            text = self.pastTapped ? [NSString stringWithFormat:@"%@%@%@",prefix,interfixB,interfixA] : [NSString stringWithFormat:@"%@%@%@",prefix,interfixA,interfixB];
            
            
            
        }
        
        
        self.instructionLabel.text=text;
        self.showInstructionLabel=NO;
    }
    
}

#pragma mark - Gestures
- (IBAction)press:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint pressLocation= [gesture locationInView: self.chooseView];
    
    
    if ( !self.movieTapped && !self.bookTapped) {
        
        if (CGRectContainsPoint(self.movieView.frame, pressLocation)) {
            NSLog(@"movie TAPPED");
            self.pastViewLabel.text= @"Watched";
            self.futureViewLabel.text=@"To See";
            self.movieTapped=YES;
            self.pastView.circelColor=self.movieView.circelColor;
            self.futureView.circelColor=self.movieView.circelColor;
            self.viewAllView.circelColor=self.movieView.circelColor;
            [self.pastView setNeedsDisplay];
            [self.futureView setNeedsDisplay];
            [self.viewAllView setNeedsDisplay];
            [self hideCircleView:self.bookView withChoicePathLayer:nil];
            [self showSecondChoice];
        }
        else if (CGRectContainsPoint(self.bookView.frame, pressLocation)){
            NSLog(@"BOOK TAPPED");
            self.pastViewLabel.text= @"Finished";
            self.futureViewLabel.text=@"To Read";
            self.bookTapped=YES;
            self.pastView.circelColor=self.bookView.circelColor;
            self.futureView.circelColor=self.bookView.circelColor;
            self.viewAllView.circelColor=self.bookView.circelColor;
            [self.viewAllView setNeedsDisplay];
            [self.pastView setNeedsDisplay];
            [self.futureView setNeedsDisplay];
            [self hideCircleView:self.movieView withChoicePathLayer:nil];
            [self showSecondChoice];
        }  
        
    }
    
    else {
        if (pressLocation.y>CGRectGetMaxY(self.movieView.frame)){
            
            if (self.movieTapped) {
                [self showCircleView:self.bookView withChoicePathLayerA:nil PathLayerB:nil];
            }
            
            if (self.bookTapped) {
                [self showCircleView:self.movieView withChoicePathLayerA:nil PathLayerB:nil];
            }
            
            [self hideSecondChoice];
            [self hideThirdChoice];
        }
        if ( !self.pastTapped && !self.futureTapped) {
            if (CGRectContainsPoint(self.pastView.frame, pressLocation)) {
                NSLog(@"PAST TAPPED");
                self.pastTapped=YES;
                [self hideCircleView:self.futureView withChoicePathLayer:self.secondChoicePathLayerB];
                [self showThirdChoice];
            }
            else if (CGRectContainsPoint(self.futureView.frame, pressLocation)){
                NSLog(@"FUTURE TAPPED");
                self.futureTapped=YES;
                [self hideCircleView:self.pastView withChoicePathLayer:self.secondChoicePathLayerA];
                [self showThirdChoice];
            }  
        }
        else if (pressLocation.y>CGRectGetMaxY(self.pastView.frame)){
            if (self.pastTapped) {
                [self showCircleView:self.futureView withChoicePathLayerA:nil PathLayerB:self.secondChoicePathLayerB];
            }
            
            if (self.futureTapped) {
                [self showCircleView:self.pastView withChoicePathLayerA:self.secondChoicePathLayerA PathLayerB:nil];
            }
            
            [self hideThirdChoice];
        }
        else if (CGRectContainsPoint(self.viewAllView.frame, pressLocation) && !self.enterTapped){
            NSLog(@"viewAll TAPPED");
            self.viewAllTapped=YES;
            [self changeInstructionText];
            [self hideCircleView:self.enterView withChoicePathLayer:self.thirdChoicePathLayerB];            
        }
        else if (CGRectContainsPoint(self.enterView.frame, pressLocation) && !self.viewAllTapped){
            NSLog(@"enter TAPPED");
            self.enterTapped=YES;
            [self changeInstructionText];
            [self hideCircleView:self.viewAllView withChoicePathLayer:self.thirdChoicePathLayerA];   
        }
        else if(self.viewAllTapped || self.enterTapped){
            if (pressLocation.y>CGRectGetMaxY(self.viewAllView.frame)){
                
                
                
                if (self.viewAllTapped) {
                    self.viewAllTapped=NO;
                    [self showCircleView:self.enterView withChoicePathLayerA:nil PathLayerB:self.thirdChoicePathLayerB];
                }
                
                if (self.enterTapped) {
                    self.enterTapped=NO;
                    [self showCircleView:self.viewAllView withChoicePathLayerA:self.thirdChoicePathLayerA PathLayerB:nil];
                }
                self.showInstructionLabel=YES;
                self.instructionLabel.text=@"";

            }            
        }
        
        if (gesture.state==UIGestureRecognizerStateEnded){
            NSLog(@"TAP END");
            if (self.enterTapped || self.viewAllTapped){
                if (self.enterTapped){
                    if (self.bookTapped){
                    [self performSegueWithIdentifier:@"AddBook" sender:self];
                    }
                    else{
                        [self performSegueWithIdentifier:@"AddMovie" sender:self];
                    }
                 }
                else {
                    if (self.bookTapped){
                        [self performSegueWithIdentifier:@"ShowBooks" sender:self];
                    }
                    else{
                        [self performSegueWithIdentifier:@"ShowMovies" sender:self];
                    }
                }
            }
            else{
                self.showInstructionLabel=YES;
                self.instructionLabel.text=@"";
                
                if (self.movieTapped) {
                    [self showCircleView:self.bookView withChoicePathLayerA:nil PathLayerB:nil];
                }
            
                if (self.bookTapped) {
                    [self showCircleView:self.movieView withChoicePathLayerA:nil PathLayerB:nil];
                }
                
                [self uncheck];
                }
        }
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.pastTapped){
        if ([segue.identifier isEqualToString:@"AddBook"]) {
            [segue.destinationViewController setTitle:@"Add Finished Book"];
            [segue.destinationViewController setFinishedBooks:YES];
        }
        else if ([segue.identifier isEqualToString:@"ShowBooks"]) {
            [segue.destinationViewController setTitleLabelText:@"Finished Books"];
            [segue.destinationViewController setShowFinishedBooks:YES];
        }
        else if ([segue.identifier isEqualToString:@"AddMovie"]) {
            [segue.destinationViewController setTitle:@"Add Watched Movie"];
            [segue.destinationViewController setWatchedMovies:YES];
        }
        else if ([segue.identifier isEqualToString:@"ShowMovies"]) {
            [segue.destinationViewController setTitleLabelText:@"Watched Movies"];
            [segue.destinationViewController setShowWatchedMovies:YES];
        }
    }
    else{
        if ([segue.identifier isEqualToString:@"AddBook"]) {
            [segue.destinationViewController setTitle:@"Add Book To Read"];
            [segue.destinationViewController setFinishedBooks:NO];
        }
        else if ([segue.identifier isEqualToString:@"ShowBooks"]) {
            [segue.destinationViewController setTitleLabelText:@"Books To Read"];
            [segue.destinationViewController setShowFinishedBooks:NO];
        }
        else if ([segue.identifier isEqualToString:@"AddMovie"]) {
            [segue.destinationViewController setTitle:@"Add Movie To See"];
            [segue.destinationViewController setWatchedMovies:NO];
        }
        else if ([segue.identifier isEqualToString:@"ShowMovies"]) {
            [segue.destinationViewController setTitleLabelText:@"Movies To See"];
            [segue.destinationViewController setShowWatchedMovies:NO];
        }
    }
    
}

- (void)instructionLabelBlink:(NSTimer*)timer
{
    self.instructionLabel.alpha=1.0;
    [UIView animateWithDuration:0.5 animations:^{
        if (self.blinkInstruction) {
            self.instructionLabel.alpha=0.5;
        }
    }completion:^(BOOL success){
        [UIView animateWithDuration:0.5 animations:^{
            if (self.blinkInstruction) {
                self.instructionLabel.alpha=1;
            }
        }completion:^(BOOL success){
            
        }];
    }];
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"back3.png"] 
                                                                           style:UIBarButtonItemStyleBordered 
                                                                          target:nil 
                                                                          action:nil];
    
    /*
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"back3.png"]]];
     */
    [self setupAnimationLayer];
    
    [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(instructionLabelBlink:) userInfo:NULL repeats:YES];
   
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [self setInfo:nil];
    [self setPastViewLabel:nil];
    [self setFutureViewLabel:nil];
    [self setInstructionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#define LABEL_BLINKING_DURATION 0.7

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    /*
    [UIView animateWithDuration:LABEL_BLINKING_DURATION delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.instructionLabel.alpha=0.5;
    }
                     completion:^(BOOL success){
                         
                         
    }];
    */
    
    self.showInstructionLabel=YES;
    self.instructionLabel.text=@"";
    
    self.movieView.circelColor = [UIColor colorWithRed:(90.0/255.0) green:(204.0/255.0) blue:(255.0/255.0) alpha:1];
  //  self.bookView.circelColor = [UIColor colorWithRed:(255.0/255.0) green:(126.0/255.0) blue:(0.0/255.0) alpha:1];
    self.bookView.circelColor = [UIColor colorWithRed:(192/255.0) green:(26/255.0) blue:(20/255.0) alpha:1];
    self.pastView.circelColor = [UIColor purpleColor];
    self.futureView.circelColor = [UIColor yellowColor];
    self.viewAllView.circelColor = [UIColor blueColor];
    self.enterView.circelColor =     [UIColor colorWithRed:(101.0/255.0) green:(223.0/255.0) blue:(109.0/255.0) alpha:1];

    
    self.movieView.alpha=0;
    self.bookView.alpha=0;
    self.pastView.alpha=0;
    self.futureView.alpha=0;
    self.viewAllView.alpha=0;
    self.enterView.alpha=0;
    
  //  self.chooseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1335.png"]];
    [self uncheck];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showFirstChoice];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationPortrait;
}


@end
