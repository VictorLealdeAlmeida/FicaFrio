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

- (void)createNewGoal:(NSString *)goalName withSteps:(NSMutableArray *)steps tags:(NSMutableArray *)tags andID:(NSString *)goalID;
- (void)setStartDate:(NSDate *)startDate toStep:(Step *)ongoingStep;
- (void)setEndDate:(NSDate *)endDate toStep:(Step *)ongoingStep;
- (void)setAvgHeartRate:(float)avgHeartRate toStep:(Step *)ongoingStep;
- (NSArray *)fetchStepsForGoalID: (NSString *)goalID;
- (Step *)fetchStep:(NSInteger)stepNumber forGoalID:(NSString *)goalID ;
- (NSArray *)fetchStepsWithTag:(NSString *)stepTag;

@end
