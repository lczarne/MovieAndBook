//
//  Book.h
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/14/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * finished;

@end
