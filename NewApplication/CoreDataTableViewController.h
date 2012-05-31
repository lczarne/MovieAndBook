//
//  CoreDataTableViewController.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/13/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@property BOOL debug;

@end
