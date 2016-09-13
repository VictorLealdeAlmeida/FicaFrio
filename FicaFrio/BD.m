//
//  BD.m
//  FicaFrio
//
//  Created by Diana Monteiro on 12/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "BD.h"
#import "AppDelegate.h"
#import "Goal.h"
#import "Step.h"

@interface BD ()

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedContext;

@end

@implementation BD

- (void)createNewGoal:(NSString *)goalName withSteps:(NSMutableArray *)steps tags:(NSMutableArray *)tags andID:(NSString *)goalID {
    NSLog(@"entered createNewGoal");
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _managedContext = [_appDelegate managedObjectContext];
    
    Goal *newGoal = (Goal *)[NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:_managedContext];
    
    newGoal.name = goalName;
    newGoal.goalID = goalID;
    //NSLog(@"%@", newGoal);
    
    for (int i = 0; i < steps.count; i++){
        Step *newStep = (Step *)[NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:_managedContext];
        newStep.name = steps[i];
        newStep.number = [NSNumber numberWithInt:i];
        newStep.tag = tags[i];
        newStep.goalName = goalName;
        newStep.goalID = goalID;
        //NSLog(@"Step %d: %@", i, newStep);
    }
    
    // Salvar goal e steps/tags no BD
    NSError *error;
    if (![_managedContext save:&error]) {
        NSLog(@"Error saving new goal: %@", [error localizedDescription]);
    }
}

//- (Step *)fetchOngoingStep {
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Step"];
//    [fetchRequest setValue:[NSNumber numberWithBool:YES] forKey:@"ongoing"];
//    
//    NSError *error;
//    NSArray *stepResults = [_managedContext executeFetchRequest:fetchRequest error:&error];
//    if (!stepResults) {
//        NSLog(@"Error fetching Step objects: %@\n%@", [error localizedDescription], [error userInfo]);
//        abort();
//        return nil;
//    }
//    else {
//        return (Step*) stepResults[0];
//    }
//}

- (void)setStartDate:(NSDate *)startDate toStep:(Step *)ongoingStep {
    if (ongoingStep != nil) {
        ongoingStep.startDate = startDate;
        
        // Salvar startDate no BD
        NSError *error;
        if (![_managedContext save:&error]) {
            NSLog(@"Error saving start date to step: %@", [error localizedDescription]);
        }
    }
}

- (void)setEndDate:(NSDate *)endDate toStep:(Step *)ongoingStep {
    if (ongoingStep != nil) {
        ongoingStep.endDate = endDate;
        NSTimeInterval intervalDuration = [endDate timeIntervalSinceDate: ongoingStep.startDate];
        ongoingStep.duration = [NSNumber numberWithDouble:intervalDuration];
        
        // Salvar endDate e duration no BD
        NSError *error;
        if (![_managedContext save:&error]) {
            NSLog(@"Error saving end date to step: %@", [error localizedDescription]);
        }
    }
}

- (NSArray *)fetchStepsForGoalID: (NSString *)goalID {
    NSLog(@"entered fetchStepsForGoalID");
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _managedContext = [_appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Step" inManagedObjectContext:_managedContext]];
    //[fetchRequest setValue:goalID forKey:@"goalID"];
    NSPredicate *predicateForGoalID = [NSPredicate predicateWithFormat:@"goalID == %@", goalID];
    [fetchRequest setPredicate:predicateForGoalID];
    
    NSError *error;
    NSArray *stepResults = [_managedContext executeFetchRequest:fetchRequest error:&error];
    if (!stepResults) {
        NSLog(@"Error fetching Step objects for goal ID %@: %@\n%@", goalID, [error localizedDescription], [error userInfo]);
        abort();
        return nil;
    }
    else {
        return stepResults;
    }
}

- (Step *)fetchStep:(NSInteger)stepNumber forGoalID:(NSString *)goalID {
    NSLog(@"entered fetchStepforGoalID");
    
    NSArray *steps = [self fetchStepsForGoalID:goalID];
    
    for (Step * step in steps){
        if ([step.number isEqualToNumber:[NSNumber numberWithInteger:stepNumber]]){
            return step;
        }
    }
    
    return nil;
}

- (NSArray *)fetchStepsWithTag:(NSString *)stepTag {
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _managedContext = [_appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //[fetchRequest setValue:stepTag forKey:@"tag"];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Step" inManagedObjectContext:_managedContext]];
    NSPredicate *predicateForStepTag = [NSPredicate predicateWithFormat:@"tag == %@", stepTag];
    [fetchRequest setPredicate:predicateForStepTag];
    
    NSError *error;
    NSArray *stepResults = [_managedContext executeFetchRequest:fetchRequest error:&error];
    if (!stepResults) {
        NSLog(@"Error fetching Step objects with tag %@: %@\n%@", stepTag, [error localizedDescription], [error userInfo]);
        abort();
        return nil;
    }
    else {
        return stepResults;
    }
}

@end
