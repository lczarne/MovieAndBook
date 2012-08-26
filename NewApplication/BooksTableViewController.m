//
//  BooksTableViewController.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "BooksTableViewController.h"
#import "Book+CreatingDeleting.h"
#import "BookDetailsViewController.h"
#import "AddBookViewController.h"
#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

@interface BooksTableViewController()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (nonatomic) CGFloat headerImageOriginYInitialValue;

@property (nonatomic,strong) Book *selectedBook;
@property BOOL someCellisSelected;
@property int selectedRow;
@property (nonatomic, strong) CustomSpecialCell* lastSelectedCell;
@property (nonatomic, strong) NSString* booksTableSortDescriptionKey;
@property (nonatomic) int booksTableSortType;
@property (nonatomic) BOOL booksTableSortAscending;

@end
@implementation BooksTableViewController

@synthesize addButton = _addButton;
@synthesize dataBase=_dataBase;
@synthesize showFinishedBooks;
@synthesize titleLabel = _titleLabel;
@synthesize loadingDataIndicator = _loadingDataIndicator;
@synthesize optionsButton = _optionsButton;

@synthesize headerImage = _headerImage;
@synthesize headerImageOriginYInitialValue=_headerImageOriginYInitialValue;

@synthesize selectedBook=_selectedBook;
@synthesize lastSelectedCell=_lastSelectedCell;
@synthesize someCellisSelected=_someCellisSelected;
@synthesize selectedRow=_selectedRow;
@synthesize booksTableSortDescriptionKey=_booksTableSortDescriptionKey;
@synthesize booksTableSortType=_booksTableSortType;
@synthesize booksTableSortAscending=_booksTableSortAscending;
@synthesize usingDatabase = _usingDatabase;


- (IBAction)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (int)booksTableSortType
{
    if(_booksTableSortType){
        return _booksTableSortType;
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

-(BOOL)booksTableSortAscending
{
    if (_booksTableSortAscending) {
        return _booksTableSortAscending;
    }
    else return NO;
}

- (NSString*)booksTableSortDescriptionKey
{
    if (_booksTableSortDescriptionKey) {
        return _booksTableSortDescriptionKey;
    }
    else return @"dateAdded";
}

- (void)setTitleLabelText:(NSString *)titleText
{
    self.titleLabel.text=titleText;
}

- (void)setupFetchedResultsController
{
    NSLog(@"setupFetchedResultsController");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    request.predicate = [NSPredicate predicateWithFormat:@"finished == %@",[NSNumber numberWithBool:self.showFinishedBooks]];
    //request.predicate = [NSPredicate predicateWithFormat:@"finished == YES"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:self.booksTableSortDescriptionKey ascending:self.booksTableSortAscending],[NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO],nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.dataBase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    if ([[self.fetchedResultsController fetchedObjects]count] == 0){
        [self hideIndicatorShowAdd];
    }
    
}

- (void)insertDataIntoDocument:(UIManagedDocument *)document
{
    
    NSLog(@"insertingDATA");
    [Book bookWithTitle:@"Potop" Author:@"Henryk Sienkiewicz" Rating:[NSNumber numberWithInt:5] Info:@"dodatkowy opis" Finished:YES inManagedObjectContext:document.managedObjectContext];
    dispatch_queue_t insertingDataQ = dispatch_queue_create("Inserting Data", NULL);
    dispatch_async(insertingDataQ, ^{
        
        //TO ADD IN FUTURE - loading data from the server
        
        [document.managedObjectContext performBlock:^{
            //inserting objects in the document in its context 
        }]; 
    });
    dispatch_release(insertingDataQ);
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.dataBase.fileURL path]]) {
       // NSLog(@"db exists");
        [self.dataBase saveToURL:self.dataBase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self setupFetchedResultsController];
            //  [self insertDataIntoDocument:self.dataBase];
        }];
    } else if (self.dataBase.documentState ==UIDocumentStateClosed){
       // NSLog(@"closed");
        [self.dataBase openWithCompletionHandler:^(BOOL suucess){
            [self setupFetchedResultsController];
            //  [self insertDataIntoDocument:self.dataBase];
        }];
    } else if (self.dataBase.documentState ==UIDocumentStateNormal){
      //  NSLog(@"normal");
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


#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    
    
    if (!self.dataBase) {
        NSLog(@"niemaDATABASE");
        NSURL *url= [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDirectory] lastObject];
        url = [url URLByAppendingPathComponent:@"MovieBooksDatabase"];
        self.dataBase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
    

}

-(void)viewDidLoad
{

    
    [super viewDidLoad];
    

    
    self.optionsButton.hidden=YES;
    self.addButton.hidden=YES;
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
    
    [self setTitleLabel:nil];
    [self setHeaderImage:nil];
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
        [segue.destinationViewController setBook:self.selectedBook];
    }
    else if([segue.identifier isEqualToString:@"goToTableOptions"]){
        
        [segue.destinationViewController setInstructionText:@"Sort books by:"];
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setSelectedSortType:self.booksTableSortType];
        
        NSArray *options=nil;
        if (self.showFinishedBooks) {
            options= [NSArray arrayWithObjects:@"Date",@"Title",@"Rating", nil];
            
        }
        else{
            options= [NSArray arrayWithObjects:@"Date",@"Title", nil];
        }
        [segue.destinationViewController setSegmentedControlOptions:options];
    }
    
    else if([segue.identifier isEqualToString:@"AddBook"]){
        self.usingDatabase = YES;
        if (self.showFinishedBooks) {
            [segue.destinationViewController setFinishedBooks:YES];
        }
        else {
            [segue.destinationViewController setFinishedBooks:NO];
        }
        
        [segue.destinationViewController setDelegate:self];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book *book= [self.fetchedResultsController objectAtIndexPath:indexPath];    
    
    static NSString *CellIdentifier = @"CustomSpecialCell";
    CustomSpecialCell *cell = (CustomSpecialCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomSpecialCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CustomSpecialCell class]])
            {
                cell = (CustomSpecialCell *)currentObject;
                break;
            }
        }        
    }
    
    
    if (self.someCellisSelected && ([indexPath row]==self.selectedRow)){
        
        cell.detailsView.hidden=NO;
        cell.basicView.hidden=YES;
        NSLog(@"detail:%d basic:%d",cell.detailsView.hidden,cell.basicView.hidden);
        
        cell.titleTextView.text=book.title;
        cell.authorLabel.text=book.author;
        
        if (![book.info length]) {
            cell.descriptionTextView.text=@"no description";
        }
        else{
            cell.descriptionTextView.text=book.info;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:book.dateAdded]];
        NSLog(@"%@",textDate);
        cell.dateAddedLabel.text=textDate;
        
        if (self.showFinishedBooks) {
            if (book.rating.intValue == 0) {
                cell.ratingLabel.text=@"not rated";
                
            }
            else{
                cell.ratingLabel.text=[NSString stringWithFormat:@"%d/10",book.rating.integerValue];
            }
            cell.finishedButton.hidden=YES;
        }
        else{
            cell.staticLabelRating.hidden=YES;
            cell.ratingLabel.hidden=YES;
        }
       
        self.selectedBook=book;
        cell.delegate=self;
        self.lastSelectedCell=cell;
        
    }
    else{
        cell.detailsView.hidden=YES;
        cell.basicView.hidden=NO;
        cell.mainTitle.text=book.title;
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
            height=180;
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
- (void)editCell:(CustomSpecialCell *)sender
{
    NSLog(@"performSeg Start");
    [self performSegueWithIdentifier:@"EditCell" sender:self];
    NSLog(@"performSeg End");
}

- (void)moveSelectedBookToFinished:(CustomSpecialCell*)sender{
    
    
    CGAffineTransform transform=self.lastSelectedCell.transform;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.lastSelectedCell.transform= CGAffineTransformScale(transform, 1.08, 1.08);
    }
    completion: ^(BOOL finished){
        [UIView animateWithDuration:0.3 animations:^{
            self.lastSelectedCell.transform= CGAffineTransformScale(transform, 0.001, 0.001);
        }
        completion: ^(BOOL finished){
            
            self.selectedBook.finished=[NSNumber numberWithBool:YES];
            self.selectedRow=-1;
            self.someCellisSelected=NO;
            self.lastSelectedCell.transform= CGAffineTransformScale(transform, 1, 1);
            self.lastSelectedCell=nil;
            
            [self.tableView reloadData];
                             
        }];
    }];
    
   /*
    BOOL finished= self.selectedBook.finished.boolValue;
    
    finished = finished ? NO : YES;
   */ 
   // self.selectedBook.finished= [NSNumber numberWithBool:finished];   
    
}

#pragma mark - bookDetailsViewDelegate

- (void)deleteBook:(Book *)book sender:(BookDetailsViewController *)sender
{
    [Book deleteBook:book inManagedObjectContext:self.dataBase.managedObjectContext];
    self.selectedRow=-1;
    self.someCellisSelected=NO;
    self.lastSelectedCell=nil;
    [self.tableView reloadData];
}

- (void)reloadAfterChanges
{
  //  [self setupFetchedResultsController];
    [self.tableView reloadData];
}

- (void)finishedUsingDatabase
{
    self.usingDatabase = NO;
}

#pragma mark - AddBookViewControllerDelegate

- (UIManagedDocument *)delegatesDataBase{
    return self.dataBase;
}

#pragma mark - TableOptionsViewControllerDelegate

- (void)changeTableSortTypeTo:(int)type sender:(TableOptionsViewController *)sender
{

    if (self.showFinishedBooks && (type==2)) {
        self.booksTableSortDescriptionKey=@"rating";
        self.booksTableSortAscending=NO;
    }
    else{
        switch (type) {
            case 0:
                self.booksTableSortDescriptionKey=@"dateAdded";
                self.booksTableSortAscending=NO;
                break;
            case 1:
                self.booksTableSortDescriptionKey=@"title";
                self.booksTableSortAscending=YES;
                break;        
            default:
                break;
        }
    }

    
    self.booksTableSortType=type;

    self.someCellisSelected= NO;
    self.selectedRow = -1;
    self.selectedBook = nil;
    
    [self setupFetchedResultsController];
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    
  

    
}


@end
