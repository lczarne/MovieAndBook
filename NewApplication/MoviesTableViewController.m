//
//  MoviesTableViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "MoviesTableViewController.h"
#import "CustomMovieCell.h"
#import "Movie+CreatingDeleting.h"
#import "AddMovieViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface MoviesTableViewController()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (nonatomic) CGFloat headerImageOriginYInitialValue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingDataIndicator;

@property (nonatomic,strong) Movie *selectedMovie;
@property BOOL someCellisSelected;
@property int selectedRow;
@property (nonatomic, strong) CustomMovieCell* lastSelectedCell;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) NSString* moviesTableSortDescriptionKey;
@property (nonatomic) int moviesTableSortType;
@property (nonatomic) BOOL moviesTableSortAscending;
@property (nonatomic) BOOL usingDatabase;

@end

@implementation MoviesTableViewController

@synthesize dataBase=_dataBase;
@synthesize titleLabel = _titleLabel;
@synthesize showWatchedMovies=_showWatchedMovies;
@synthesize addButton = _addButton;

@synthesize headerImage=_headerImage;
@synthesize headerImageOriginYInitialValue=_headerImageOriginYInitialValue;
@synthesize loadingDataIndicator = _loadingDataIndicator;

@synthesize selectedMovie=_selectedMovie;
@synthesize someCellisSelected=_someCellisSelected;
@synthesize selectedRow=_selectedRow;
@synthesize lastSelectedCell=_lastSelectedCell;
@synthesize optionsButton = _optionsButton;
@synthesize moviesTableSortDescriptionKey=_moviesTableSortDescriptionKey;
@synthesize moviesTableSortAscending=_moviesTableSortAscending;
@synthesize moviesTableSortType=_moviesTableSortType;
@synthesize usingDatabase;

- (IBAction)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (int)moviesTableSortType
{
    if(_moviesTableSortType){
        return _moviesTableSortType;
    }
    else{
        return  0;
    }
    
}

- (void)hideIndicatorShowAdd
{
    [self.loadingDataIndicator stopAnimating];
    self.addButton.hidden=NO;
    self.optionsButton.hidden=NO;
}

-(BOOL)moviesTableSortAscending
{
    if (_moviesTableSortAscending) {
        return _moviesTableSortAscending;
    }
    else return NO;
}

- (NSString*)moviesTableSortDescriptionKey
{
    if (_moviesTableSortDescriptionKey) {
        return _moviesTableSortDescriptionKey;
    }
    else return @"dateAdded";
}

- (void)setTitleLabelText:(NSString *)titleText{
    self.titleLabel.text=titleText;
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.predicate = [NSPredicate predicateWithFormat:@"watched == %@",[NSNumber numberWithBool:self.showWatchedMovies]];
    //request.predicate = [NSPredicate predicateWithFormat:@"finished == YES"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:self.moviesTableSortDescriptionKey ascending:self.moviesTableSortAscending],[NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO],nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.dataBase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    if ([[self.fetchedResultsController fetchedObjects]count] == 0){
        [self hideIndicatorShowAdd];
    }
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.dataBase.fileURL path]]) {
        [self.dataBase saveToURL:self.dataBase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self setupFetchedResultsController];
            //  [self insertDataIntoDocument:self.dataBase];
        }];
    } else if (self.dataBase.documentState ==UIDocumentStateClosed){
        [self.dataBase openWithCompletionHandler:^(BOOL suucess){
            [self setupFetchedResultsController];
            //  [self insertDataIntoDocument:self.dataBase];
        }];
    } else if (self.dataBase.documentState ==UIDocumentStateNormal){
        [self setupFetchedResultsController];
    }
}

- (void)setDataBase:(UIManagedDocument *)dataBase
{
    if (_dataBase!=dataBase) {
        _dataBase=dataBase;
        [self useDocument];
    }
}


#pragma mark - View Lifcycle
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.dataBase) {
        NSURL *url= [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDirectory] lastObject];
        url = [url URLByAppendingPathComponent:@"MovieBooksDatabase"];
        self.dataBase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.optionsButton.hidden=YES;
    self.addButton.hidden= YES;
    [self.loadingDataIndicator startAnimating];
    self.headerImageOriginYInitialValue = self.headerImage.frame.origin.y;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.dataBase.managedObjectContext save:nil];
    [self.dataBase savePresentedItemChangesWithCompletionHandler:^(NSError *error){
    } ];
    [super viewWillDisappear:animated];
    if (!self.usingDatabase) {
        
        [self.dataBase closeWithCompletionHandler:^(BOOL suucess){
        }];
    }
}

- (void)viewDidUnload {
    [self setHeaderImage:nil];
    [self setTitleLabel:nil];
    [self setLoadingDataIndicator:nil];
    [self setOptionsButton:nil];
    [self setAddButton:nil];
    [super viewDidUnload];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    
    if ([segue.identifier isEqualToString:@"EditCell"]) {
        self.usingDatabase = YES;
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setMovie:self.selectedMovie];
    }
    else if([segue.identifier isEqualToString:@"goToTableOptions"]){
        [segue.destinationViewController setInstructionText:@"Sort movies by:"];
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setSelectedSortType:self.moviesTableSortType];
        
        NSArray *options=nil;
        if (self.showWatchedMovies) {
            options= [NSArray arrayWithObjects:@"Date",@"Title",@"Rating", nil];
            
        }
        else{
            options= [NSArray arrayWithObjects:@"Date",@"Title", nil];
        }
        [segue.destinationViewController setSegmentedControlOptions:options];
    }
    
    else if([segue.identifier isEqualToString:@"AddMovie"]){
        self.usingDatabase = YES;
        if (self.showWatchedMovies) {
            [segue.destinationViewController setWatchedMovies:YES];
        }
        else {
            [segue.destinationViewController setWatchedMovies:NO];
        }
        
        [segue.destinationViewController setDelegate:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie= [self.fetchedResultsController objectAtIndexPath:indexPath];    
    
    static NSString *CellIdentifier = @"CustomMovieCell";
    CustomMovieCell *cell = (CustomMovieCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomMovieCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CustomMovieCell class]])
            {
                cell = (CustomMovieCell *)currentObject;
                break;
            }
        }        
    }
    
    
    if (self.someCellisSelected && ([indexPath row]==self.selectedRow)){
        
        cell.detailsView.hidden=NO;
        cell.basicView.hidden=YES;
        
        cell.titleDetailsLabel.text =movie.title;
        if (![movie.info length]) {
            cell.infoLabel.text=@"no description";
        }
        else{
            cell.infoLabel.text=movie.info;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:movie.dateAdded]];
        cell.dateAddedLabel.text=textDate;
        
        if (self.showWatchedMovies) {
            if (movie.rating.intValue == 0) {
                cell.ratingLabel.text=@"not rated";
                
            }
            else{
                cell.ratingLabel.text=[NSString stringWithFormat:@"%d/10",movie.rating.integerValue];
            }
            cell.watchedButton.hidden=YES;
            cell.shareButton.hidden = NO;
            //cell.watchedButton.titleLabel.text = @"Share";
        }
        else{
            cell.staticLabelRating.hidden=YES;
            cell.ratingLabel.hidden=YES;
            cell.watchedButton.hidden=NO;
            cell.shareButton.hidden = YES;
        }
        
        self.selectedMovie=movie;
        cell.delegate=self;
        self.lastSelectedCell=cell;
        
    }
    else{
        cell.detailsView.hidden=YES;
        cell.basicView.hidden=NO;
        cell.titleMainLabel.text=movie.title;
    }
    
    
    if (!self.loadingDataIndicator.hidden){
        [self hideIndicatorShowAdd];
    }
     
    return cell;
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    //if new cell was selected
    if ([indexPath row]!=self.selectedRow){
        
        //if other cell is opened
        //have to check if lastSelected exists (might be deleted 
        if (self.lastSelectedCell && self.someCellisSelected) {
            self.lastSelectedCell.basicView.hidden=NO;
            self.lastSelectedCell.detailsView.hidden=YES;
            self.selectedRow=[indexPath row];
            NSIndexPath *selectedIndex = [self.tableView indexPathForCell:self.lastSelectedCell];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        self.selectedRow=[indexPath row];
        self.someCellisSelected=YES;
        
    }
    //if selected cell was last one selected
    else{
        //if it is still opened
        if (self.someCellisSelected) {
            self.someCellisSelected=NO;
        }
        //if it was closed
        else{
            self.someCellisSelected=YES;
        }
    }
    
    if (self.someCellisSelected) {
        
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        //   [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        
    }
    else{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        //   [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=55;
    if (self.someCellisSelected) {
        if ([indexPath row] == self.selectedRow) {
            height=178;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor= [UIColor clearColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat headerImageOriginYChange= scrollView.contentOffset.y/2;
    CGFloat headerImageAlphaChange= -1 * (scrollView.contentOffset.y/400);
    if (headerImageOriginYChange>0) {
        headerImageOriginYChange=0;
    }
    else if (headerImageOriginYChange <-100){
        headerImageOriginYChange=-100;
    }
    
    self.headerImage.alpha=0.8+headerImageAlphaChange;
    self.headerImage.frame= CGRectMake(self.headerImage.frame.origin.x, self.headerImageOriginYInitialValue+headerImageOriginYChange, self.headerImage.frame.size.width, self.headerImage.frame.size.height);
}
  
#pragma mark - customSpecialCellDelegate

- (void)shareWatchedMovie
{
    [self share];
}

- (void)editCell:(CustomMovieCell *)sender
{
    [self performSegueWithIdentifier:@"EditCell" sender:self];
}

- (void)moveSelectedMovieToWatched:(CustomMovieCell *)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Move to Watched?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Move & Share", @"Move", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showInView:self.view];
    

    //[self moveToWatched];
}

- (void)moveToWatched
{
    CGAffineTransform transform=self.lastSelectedCell.transform;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.lastSelectedCell.transform= CGAffineTransformScale(transform, 1.08, 1.08);
    }
     completion: ^(BOOL finished){
         [UIView animateWithDuration:0.3 animations:^{
             self.lastSelectedCell.transform= CGAffineTransformScale(transform, 0.001, 0.001);
         }
          completion: ^(BOOL finished){
              self.selectedMovie.watched=[NSNumber numberWithBool:YES];
              self.selectedRow=-1;
              self.someCellisSelected=NO;
              self.selectedMovie.dateAdded = [NSDate date];
              self.lastSelectedCell.transform= CGAffineTransformScale(transform, 1, 1);
              self.lastSelectedCell=nil;
              
              [self.tableView reloadData];
          }];
     }];
}

#pragma mark - movieDetailsViewDelegate

- (void)deleteMovie:(Movie *)movie sender:(MovieDetailsViewController *)sender
{
    [Movie deleteMovie:movie inManagedObjectContext:self.dataBase.managedObjectContext];
    self.selectedRow=-1;
    self.someCellisSelected=NO;
    self.lastSelectedCell=nil;
    [self.tableView reloadData];
}

-(void)reloadAfterChanges
{
    
    // [self setupFetchedResultsController];
    [self.tableView reloadData];
}

- (void)finishedUsingDatabase
{
    self.usingDatabase = NO;
}

#pragma mark - AddMovieViewControllerDelegate

- (UIManagedDocument *)delegatesDataBase{
    return self.dataBase;
}

#pragma mark - TableOptionsViewControllerDelegate

- (void)changeTableSortTypeTo:(int)type sender:(TableOptionsViewController *)sender
{
    
    if (self.showWatchedMovies && (type==2)) {
        self.moviesTableSortDescriptionKey=@"rating";
        self.moviesTableSortAscending=NO;
    }
    else{
        switch (type) {
            case 0:
                self.moviesTableSortDescriptionKey=@"dateAdded";
                self.moviesTableSortAscending=NO;
                break;
            case 1:
                self.moviesTableSortDescriptionKey=@"title";
                self.moviesTableSortAscending=YES;
                break;        
            default:
                break;
        }
    }
    
    
    self.moviesTableSortType=type;
    
    self.someCellisSelected= NO;
    self.selectedRow = -1;
    self.selectedMovie = nil;
    
    [self setupFetchedResultsController];
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    
    
}

#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    
     switch (buttonIndex) {
     case 0:
             [self moveToWatched];
             [self share];
             break;
     case 1:
             [self moveToWatched];
             break;
     case 2:
             
             break;

     }
     
}

#pragma mark - facebook sharing

- (void)publishStory
{
    NSString *message = [NSString stringWithFormat:@"Added movie"];
    
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    NSString *alertText;
                                    if (error) {
                                        alertText = [NSString stringWithFormat:
                                                     @"There was a problem with Facebook connection"];
                                    } else {
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
