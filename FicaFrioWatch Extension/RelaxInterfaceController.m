//
//  RelaxInterfaceController.m
//  FicaFrio
//
//  Created by Bárbara Souza on 21/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "RelaxInterfaceController.h"
@import HealthKit;

@interface RelaxInterfaceController () <HKWorkoutSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *relaxImage;

@property (nonatomic, retain) HKHealthStore *healthStore; // retain ou strong?
@property (nonatomic, retain) HKWorkoutSession *workoutSession;
@property (nonatomic, retain) NSDate *startStepDate;
@property (nonatomic, retain) NSDate *endStepDate;
@property (nonatomic, retain) HKQueryAnchor *lastAnchor;
@property (nonatomic, retain) HKQuantity *averageHeartRate;
@property (nonatomic, retain) HKAnchoredObjectQuery *heartQuery;
@property (nonatomic, retain) HKQuantityType *heartType;
@property (nonatomic, retain) NSMutableArray *sampleValues;

@end

@implementation RelaxInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [_relaxImage setImageNamed:@"respirar"];
    [_relaxImage startAnimatingWithImagesInRange: NSMakeRange(1, 70) duration:5 repeatCount:100];
    
    // Configure interface objects here.
    self.lastAnchor = 0;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// CHAMAR ESSAS FUNÇÕES ---------------------------------------------------

- (void)startStoringHeartRate {
    self.startStepDate = [NSDate date];
    self.workoutSession = [[HKWorkoutSession alloc] initWithActivityType:HKWorkoutActivityTypeOther locationType:HKWorkoutSessionLocationTypeUnknown];
    self.workoutSession.delegate = self;
    NSLog(@"start");
    
    [self requestAuthorization];
    [self.healthStore startWorkoutSession:self.workoutSession];
    
    //[self streamQueryHeartRateData];
}

- (void)stopStoringHeartRate {
    [self.healthStore endWorkoutSession:self.workoutSession]; // Stop workout session
    [self.healthStore stopQuery:self.heartQuery];     // Stop query that "measures" anxiety
    self.endStepDate = [NSDate date];                 // Date when the step ends
    NSLog(@"stop");
}

// ------------------------------------------------------------------------

-(void)workoutSession:(HKWorkoutSession *)workoutSession didFailWithError:(NSError *)error{
    NSLog(@"session error %@", error);
}

-(void)workoutSession:(HKWorkoutSession *)workoutSession didChangeToState:(HKWorkoutSessionState)toState fromState:(HKWorkoutSessionState)fromState date:(NSDate *)date{
    NSLog(@"entered workout session");
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (toState) {
            case HKWorkoutSessionStateRunning:
                
                //When workout state is running, we will excute updateHeartbeat
                [self streamQueryHeartRateData];
                NSLog(@"started workout");
                break;
            case HKWorkoutSessionStateEnded:
                [self statisticsQueryHeartRateData];
                NSLog(@"ended workout");
                break;
            default:
                break;
        }
    });
}


- (void)streamQueryHeartRateData {
    // Define predicate - only pick samples that start at the startStepDate
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:self.startStepDate endDate:nil options:HKQueryOptionStrictStartDate];
    
    // Define query - the anchored query picks samples starting from "anchor", which is updated at each call, thus getting all the samples since the last call
    self.heartQuery = [[HKAnchoredObjectQuery alloc] initWithType:self.heartType predicate:predicate anchor:self.lastAnchor limit:HKObjectQueryNoLimit resultsHandler:^(HKAnchoredObjectQuery *query, NSArray<HKSample *> *sampleObjects, NSArray<HKDeletedObject *> *deletedObjects, HKQueryAnchor *newAnchor, NSError *error) {
        
        NSLog(@"entered streaming");
        NSLog(@"%@", sampleObjects);
        
        if (!error && sampleObjects.count > 0) {
            self.lastAnchor = newAnchor;
            NSLog(@"%@", sampleObjects);
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    self.heartQuery.updateHandler = ^(HKAnchoredObjectQuery *query, NSArray<HKSample *> *sampleObjects, NSArray<HKDeletedObject *> *deletedObjects, HKQueryAnchor *newAnchor, NSError *error) {
        
        NSLog(@"entered streaming");
        
        if (!error && sampleObjects.count > 0) {
            _lastAnchor = newAnchor;
            
            NSLog(@"%@", sampleObjects);
            
            //            for (HKQuantitySample *sample in sampleObjects){
            //                if (sample.quantity > 100) {
            //                    // notifica para técnica de respiração
            //                    NSLog(@"respiração");
            //                    break;
            //                }
            //            }
        }
        else {
            NSLog(@"%@", error);
        }
    };
    
    // Execute the query. It only stops when the step is finished
    [self.healthStore executeQuery:self.heartQuery];
}


- (void)statisticsQueryHeartRateData {
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:_startStepDate endDate:_endStepDate options:HKQueryOptionNone];
    
    HKStatisticsQuery *squery = [[HKStatisticsQuery alloc] initWithQuantityType:self.heartType quantitySamplePredicate:predicate options:HKStatisticsOptionDiscreteAverage+HKStatisticsOptionDiscreteMax completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *quantity = result.averageQuantity;
        HKQuantity *maximum = result.maximumQuantity;
        NSLog(@"Results: %@", result);
        NSLog(@"Average: %@, Maximum: %@", quantity, maximum);
        self.averageHeartRate = quantity;
        double average = [quantity doubleValueForUnit:[HKUnit unitFromString:@"count/min"]];
        double max = [maximum doubleValueForUnit:[HKUnit unitFromString:@"count/min"]];
        NSLog(@"Avg: %f, Max: %f", average, max);
        NSLog(@"%@", error);
        //dispatch_async(dispatch_get_main_queue(), ^{  // for updates in UI
        //});
    }];
    
    [self.healthStore executeQuery:squery];
}


- (void)requestAuthorization {
    
    if ([HKHealthStore isHealthDataAvailable] == NO) {
        // If our device doesn't support HealthKit
        return;
    }
    else {
        // If our device supports HealthKit -> initialize health store
        self.healthStore = [[HKHealthStore alloc] init];
        // Define sample type - only pick samples of heart rate
        self.heartType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
        
        NSSet *readObjectTypes = [NSSet setWithObject: [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]];
        
        [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError *error) {
            
            if (success == YES){
                NSLog(@"health data request success");
                
                HKAuthorizationStatus heartAuthorization = [self.healthStore authorizationStatusForType:self.heartType];
                if (heartAuthorization == HKAuthorizationStatusSharingAuthorized) {
                    NSLog(@"authorized");
                }
                else if (heartAuthorization == HKAuthorizationStatusNotDetermined) {
                    NSLog(@"not determined");
                }
                else if (heartAuthorization == HKAuthorizationStatusSharingDenied) {
                    NSLog(@"denied");
                }
            }
            else {
                NSLog(@"error %@", error);
                // determinar se foi um erro ou se o usuário cancelou a autorização
            }
        }];
    }
}

@end



