//
//  Goal+CoreDataProperties.h
//  FicaFrio
//
//  Created by Diana Monteiro on 12/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Goal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Goal (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *goalID;

@end

NS_ASSUME_NONNULL_END
