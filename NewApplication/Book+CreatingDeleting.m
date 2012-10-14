//
//  Book+Creating.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "Book+CreatingDeleting.h"

@implementation Book (Creating)
+ (Book*)bookWithTitle:(NSString *)title 
                Author:(NSString *)author 
                Rating:(NSNumber *)rating 
                  Info:(NSString *)info 
              Finished:(BOOL)finished
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Book *book=nil;
    
    book= [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:context];
    book.title=title;
    book.author=author;
    book.rating=rating;
    book.info=info;
    book.finished=[NSNumber numberWithBool:finished];
    book.dateAdded=[NSDate date];
    return book;
}

+ (void)deleteBook:(Book*)book inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:book];
}


@end
