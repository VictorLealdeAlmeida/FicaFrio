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
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _managedContext = [_appDelegate managedObjectContext];
    
    Goal *newGoal = (Goal *)[NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:_managedContext];
    
    newGoal.name = goalName;
    newGoal.goalID = goalID;
    
    for (int i = 0; i < steps.count; i++){
        Step *newStep = (Step *)[NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:_managedContext];
        newStep.name = steps[i];
        newStep.number = [NSNumber numberWithInt:i];
        newStep.tag = tags[i];
        newStep.goalName = goalName;
        newStep.goalID = goalID;
    }
    
    // Salvar goal e steps/tags no BD
    NSError *error;
    if (![_managedContext save:&error]) {
        NSLog(@"Error saving new goal: %@", [error localizedDescription]);
    }
}

- (Step *)fetchOngoingStep {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Step"];
    [fetchRequest setValue:[NSNumber numberWithBool:YES] forKey:@"ongoing"];
    
    NSError *error;
    NSArray *stepResults = [_managedContext executeFetchRequest:fetchRequest error:&error];
    if (!stepResults) {
        NSLog(@"Error fetching Step objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
        return nil;
    }
    else {
        return (Step*) stepResults[0];
    }
}

- (void)setStartDate:(NSDate *)startDate {
    Step* ongoingStep = [self fetchOngoingStep];
    
    if (ongoingStep != nil) {
        ongoingStep.startDate = startDate;
        
        // Salvar startDate no BD
        NSError *error;
        if (![_managedContext save:&error]) {
            NSLog(@"Error saving start date to step: %@", [error localizedDescription]);
        }
    }
}

- (void)setEndDate:(NSDate *)endDate {
    Step* ongoingStep = [self fetchOngoingStep];
    
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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Step"];
    [fetchRequest setValue:goalID forKey:@"goalID"];
    
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

- (NSArray *)fetchStepsWithTag:(NSString *)stepTag {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Step"];
    [fetchRequest setValue:stepTag forKey:@"tag"];
    
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
