//
//  CurrentWatchViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 20/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "CurrentWatchViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
@import HealthKit;

@interface CurrentWatchViewController() <WCSessionDelegate, HKWorkoutSessionDelegate> {
    BOOL flag;
    // MÉDIA DOS BATIMENTOS PARA PASSAR P/ IPHONE - ver se precisa passar dentro do handler em statisticsQueryHeartRateData
    NSMutableArray<NSNumber*> *avgHeartRateteps;
    double avgHeartRate;
}
- (IBAction)showStep;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *stepButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageSet;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *stepImage;
- (IBAction)startStopButton;

@property (nonatomic, retain) HKHealthStore *healthStore; // retain ou strong?
@property (nonatomic, retain) HKWorkoutSession *workoutSession;
@property (nonatomic, retain) NSDate *startStepDate;
@property (nonatomic, retain) NSDate *endStepDate;
@property (nonatomic, retain) HKQueryAnchor *lastAnchor;
@property (nonatomic, retain) HKQuantity *averageHeartRate;
@property (nonatomic, retain) HKAnchoredObjectQuery *heartQuery;
@property (nonatomic, retain) HKQuantityType *heartType;
@property (nonatomic, retain) NSMutableArray *sampleValues;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *relaxButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *stepText;


//@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *teste;

@end

@implementation CurrentWatchViewController

bool statusButton = false;
bool statusConnection = false;
int step = 0;
NSMutableArray<NSString*> *mutableArray;


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self requestAuthorization];
    
    mutableArray = [[NSMutableArray alloc] init];
    
    flag = NO;
    [_imageSet setImageNamed:@"relogio"];
    
    self.lastAnchor = 0;
    _stepImage.hidden = NO;
    _stepButton.hidden = YES;
    [_stepImage setImageNamed:@"GifInicial_Concertado-"];
    [_stepImage startAnimatingWithImagesInRange:  NSMakeRange(1, 19) duration:2 repeatCount:1000];
    avgHeartRateteps = [[NSMutableArray alloc] init];
    //[_stepText setText:NSLocalizedString(@"No goals", "")];
    //_stepText.hidden = false;
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
    }
    
    //Pra buscar conexao com tela current
    NSMutableDictionary *sendMsg;
    sendMsg = [[NSMutableDictionary alloc] init];
    sendMsg[@"callCurrent"]=@1;
    
    [[WCSession defaultSession]  sendMessage: sendMsg replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
    } errorHandler:^(NSError * _Nonnull error) {
        
    }];

}

- (void)willActivate {
    NSMutableDictionary *sendMsg;
    sendMsg = [[NSMutableDictionary alloc] init];
    sendMsg[@"callStep"]=@1;
    
    [[WCSession defaultSession]  sendMessage: sendMsg replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
       // step = [((NSNumber*)(replyMessage[@"callStep"])) integerValue];
    } errorHandler:^(NSError * _Nonnull error) {
        
    }];
    
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)startStopButton {
    if (!flag){
        //Por aq vai passar o valor pra ligar o stop no ios
        NSString *startStop = [NSString stringWithFormat:@"%d", 2];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToIphone"]];
        
        [[WCSession defaultSession] sendMessage:applicationData
                                   replyHandler:^(NSDictionary *reply) {
                                       //handle reply from iPhone app here
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       NSLog(@"Deu erro");
                                   }
         ];
    }else{
        step++;
        //Por aq vai passar o valor pra ligar o start no ios
        NSString *startStop = [NSString stringWithFormat:@"%d", 1];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToIphone"]];
        
        [[WCSession defaultSession] sendMessage:applicationData
                                   replyHandler:^(NSDictionary *reply) {
                                       //handle reply from iPhone app here
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       NSLog(@"Deu erro");
                                   }
         ];
    }
    
    [self changeStartButton];
    
}

- (void)changeStartButton {
    if (flag){
        [_imageSet stopAnimating];
        [_imageSet setImageNamed:@"relogio"];
        flag = NO;
        if(step < 3){
            [_stepButton setBackgroundImageNamed: [NSString stringWithFormat:@"bola%d", (step+1)]];
        }
        [self stopStoringHeartRate];
        //Finaliza a sessao
        if(step == 3){
            //step = 0;
            //_stepLabel.hidden = true;
            _relaxButton.hidden = YES;
            statusConnection = NO;
            _stepButton.hidden = YES;
           
        }
    }else{
        [_imageSet setImageNamed:@"relogio"];
        [_imageSet startAnimating];
        flag = YES;
        avgHeartRate = 0.0;
        _stepImage.hidden = true;
       [self startStoringHeartRate];
        
        //Aumentar a label do watch

        //step++;
        //[_stepImage setImageNamed: [NSString stringWithFormat:@"bola%d", step]];
        //_stepLabel.text = [NSString stringWithFormat:@"%d", step];
    }
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    NSLog(@"RESULTADO %@",message[@"callStepValue"]);

    NSString *counterV = [message objectForKey:@"callStepValue"];
    


    //Quando iniciar a comunicacao, mostrar as views
    if(!statusConnection){
        if (mutableArray.count > 0){
            mutableArray[0] = [message objectForKey:@"textToWatch0"];
            mutableArray[1] = [message objectForKey:@"textToWatch1"];
            mutableArray[2] = [message objectForKey:@"textToWatch2"];
        }else{
            [mutableArray addObject:[message objectForKey:@"textToWatch0"]];
            [mutableArray addObject:[message objectForKey:@"textToWatch1"]];
            [mutableArray addObject:[message objectForKey:@"textToWatch2"]];
        }
        _stepButton.hidden = NO;
        _relaxButton.hidden = false;
        _imageSet.hidden = false;
        _stepText.hidden = YES;
        _stepImage.hidden = YES;
        [_stepButton setBackgroundImageNamed: @"bola1"];
        statusConnection = true;
        
    }else{
        /*NSString *counterValue = [message objectForKey:@"startStopToWatch"];
        //2 == stop
        if ([counterValue integerValue] == 2){
            statusButton = true;
            [self changeStartButton];
        }else if ([counterValue integerValue] == 1){
            statusButton = false;
            [self changeStartButton];
        }*/
        
        //Solucao "O pitch é amanhã"
        //Virificando o status do ios
        //Primeiro numero o passo o segundo 0 pra false e 1 pra true
        if([counterV  isEqual: @"10"]){
            step = 0;
            flag = YES;
            statusButton = false;
        }else if([counterV  isEqual: @"11"]){
            step = 0;
            flag = NO;
            statusButton = true;
        }else if([counterV  isEqual: @"20"]){
            step = 1;
            flag = YES;
            statusButton = false;
        }else if([counterV  isEqual: @"21"]){
            step = 1;
            flag = NO;
            statusButton = true;
        }else if([counterV  isEqual: @"30"]){
            step = 2;
            flag = YES;
            statusButton = false;
        }else if([counterV  isEqual: @"31"]){
            step = 2;
            flag = NO;
            statusButton = true;
        }else if([counterV  isEqual: @"40"]){
            step = 3;
            flag = YES;
            statusButton = NO;
        }
        [self changeStartButton];//Mudar nome do botao ele serve pra ligar e desligar
        //_teste.text = counterV;

    
    }


}

// CHAMAR ESSAS FUNÇÕES ---------------------------------------------------

- (void)startStoringHeartRate {
    self.startStepDate = [NSDate date];
    // deprecated:
    self.workoutSession = [[HKWorkoutSession alloc] initWithActivityType:HKWorkoutActivityTypeOther locationType:HKWorkoutSessionLocationTypeUnknown];
    //HKWorkoutConfiguration *workoutConfig = [HKWorkoutConfiguration init];
    //NSError *error;
    //workoutConfig.activityType = HKWorkoutActivityTypeOther;
    //self.workoutSession = [[HKWorkoutSession alloc] initWithConfiguration:workoutConfig error:&error];
    self.workoutSession.delegate = self;
    //NSLog(@"start");
    
    [self.healthStore startWorkoutSession:self.workoutSession];
    
    [self streamQueryHeartRateData];
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
        // PASSAR PARA O IPHONE POR AQUI?
        avgHeartRate = average;
        if (avgHeartRateteps.count == 3){
            [avgHeartRateteps removeAllObjects];
        }
        [avgHeartRateteps addObject: [NSNumber numberWithDouble: average]];
        if(step == 3){
            step = 0;
            _stepText.hidden = NO;
            _stepImage.hidden = NO;
            _imageSet.hidden = YES;
            //Verificar qual passo deixou mais ansioso e enviar o numero do passo e a Tag
            [self pushControllerWithName: @"endView" context: avgHeartRateteps];
        }
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


- (IBAction)showStep {
    [self pushControllerWithName: @"showStep" context: [NSString stringWithFormat: @"%@", mutableArray[step]]];
}
@end
