//
//  Movie+Creating.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "Movie+CreatingDeleting.h"

@implementation Movie (Creating)

+ (Movie*)movieWithTitle:(NSString *)title 
                  Rating:(NSNumber *)rating 
                    Info:(NSString *)info 
                 Watched:(BOOL)watched
  inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Movie *movie=nil;
    movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
    movie.title=title;
    movie.rating=rating;
    movie.info=info;
    movie.watched=[NSNumber numberWithBool:watched];
    movie.dateAdded=[NSDate date];
    
    NSLog(@"new movie: %@ watched:%d",movie.title, [movie.watched intValue]);
    return movie;
}

+ (void)deleteMovie:(Movie*)movie inManagedObjectContext:(NSManagedObjectContext *)context{
    [context deleteObject:movie];
}

@end
