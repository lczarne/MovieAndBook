//
//  Book+Creating.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "Book.h"
/*
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * info;
*/

@interface Book (Creating)
+ (Book*)bookWithTitle:(NSString *)title 
                Author:(NSString *)author
                Rating:(NSNumber *)rating 
                  Info:(NSString *)info
              Finished:(BOOL)finished
inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteBook:(Book*)book inManagedObjectContext:(NSManagedObjectContext *)context;
@end
