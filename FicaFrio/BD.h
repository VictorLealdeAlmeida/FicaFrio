//
//  BD.h
//  FicaFrio
//
//  Created by Diana Monteiro on 12/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"

@interface BD : NSObject

- (void)createNewGoal:(NSString *)goalName withSteps:(NSMutableArray *)steps andTags:(NSMutableArray *)tags;
- (Step *)fetchOngoingStep;
- (void)setStartDate:(NSDate *)startDate;
- (void)setEndDate:(NSDate *)endDate;
- (NSArray *)fetchStepsForGoalID:(NSString *)goalID;
- (NSArray *)fetchStepsWithTag:(NSString *)stepTag;

@end
