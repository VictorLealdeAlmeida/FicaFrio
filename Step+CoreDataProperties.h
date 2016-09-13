//
//  Step+CoreDataProperties.h
//  FicaFrio
//
//  Created by Diana Monteiro on 12/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Step.h"

NS_ASSUME_NONNULL_BEGIN

@interface Step (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) NSNumber *number;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSNumber *avgHeartRate;
@property (nullable, nonatomic, retain) NSString *goalID;
@property (nullable, nonatomic, retain) NSString *goalName;
@property (nullable, nonatomic, retain) NSNumber *duration;

@end

NS_ASSUME_NONNULL_END
