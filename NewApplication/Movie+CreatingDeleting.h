//
//  Movie+Creating.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "Movie.h"

@interface Movie (Creating)

+ (Movie*)movieWithTitle:(NSString *)title 
                  Rating:(NSNumber *)rating 
                    Info:(NSString *)info 
                 Watched:(BOOL)watched
inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteMovie:(Movie*)movie inManagedObjectContext:(NSManagedObjectContext *)context;
@end
