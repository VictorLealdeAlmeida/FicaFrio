//
//  CurrentStepViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "CurrentStepViewController.h"
#import "FicaFrio-Swift.h"
#import "Step.h"
#import "BD.h"
#import "FicaFrio-Swift.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface CurrentStepViewController () <WCSessionDelegate>{
    BD *database;
    NSUserDefaults *defaults;
    NSInteger stepNumber;
    NSString *goalID;
    Step *currentStep;
    Step *stepsWatch;
    NSDate *dateTime;
    NSTimer *timerAnimation;
    bool selectHeart;
    bool stepStarted;
    UIView *currentPopup;
}

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *labelStep;
@property (weak, nonatomic) IBOutlet UIButton *endStep;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//Popups
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *grafButton;
@property (weak, nonatomic) IBOutlet UILabel *backLabel; // Nova Meta
@property (weak, nonatomic) IBOutlet UILabel *infoLabel; // Avaliação da Tarefa
@property (weak, nonatomic) IBOutlet UILabel *grafLabel; // Avaliação Geral
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurBackground;
@property (weak, nonatomic) IBOutlet UIView *confirmPopupView;
@property (weak, nonatomic) IBOutlet UIView *relaxPopupView;
@property (weak, nonatomic) IBOutlet UIView *tutorialPopupView;
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;
@property (weak, nonatomic) IBOutlet UILabel *measureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gifTutorial;


//Actions popup
- (IBAction)newGoal:(id)sender;
- (IBAction)startStopStep:(id)sender;
- (IBAction)startRelax:(UIButton *)sender;
- (IBAction)justRelax:(UIButton *)sender;
- (IBAction)relaxAndMeasure:(UIButton *)sender;
- (IBAction)goToRelax:(UIButton *)sender;
- (IBAction)clickOutsidePopup:(UITapGestureRecognizer *)sender;


@end


@implementation CurrentStepViewController

NSMutableArray<NSString *>* stepsText;

- (void)viewDidLoad {
    [super viewDidLoad];
    stepsText = [[NSMutableArray alloc] init];
    
    _titleLabel.text = NSLocalizedString(@"Steps", "");
    
    _tutorialLabel.text = NSLocalizedString(@"To measure your heart rate, put the tip of your index finger on the camera:", "");
    _measureLabel.text = NSLocalizedString(@"Do you want to measure your heart rate while breathing?", "");
    
    _backLabel.text = NSLocalizedString(@"New Goal", @"");
    _infoLabel.text = NSLocalizedString(@"Goal Feedback", @"");
    _grafLabel.text = NSLocalizedString(@"Total Feedback", @"");
    
    UIImage *logoGif = [UIImage gifImageWithName:@"Gif_Heart_Rate"];
    [_gifTutorial setImage:logoGif];
    
    selectHeart = false;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    // Get current step (goal and number)
    goalID = [defaults stringForKey:@"currentGoalID"];
    stepNumber = [defaults integerForKey:@"currentStepNumber"];
    stepStarted = [defaults boolForKey:@"stepStarted"];
    
    [self updateStep];
    [self updateCircleRotation];
    
    //Inicando comunicaçao com o relogio
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
        
      /*  //Envia o 1 pra informar o watch que o play foi selecionado
        NSString *startStop = [NSString stringWithFormat:@"%d", 12121];
        NSDictionary *applicationData2 = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToWatch"]];
        
        [[WCSession defaultSession] sendMessage:applicationData2
                                   replyHandler:^(NSDictionary *reply) {
                                       //handle reply from iPhone app here
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       NSLog(@"Deu erro");
                                   }
         ];*/
        
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    selectHeart = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGoal:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// When start button is clicked
- (IBAction)startStopStep:(id)sender {
    [self startStopStepAction];
}

- (void)startStopStepAction{
    
    if (!stepStarted){
        [self startAction];
        
        //Envia o 1 pra informar o watch que o play foi selecionado
        //2 significa desligado
        NSString *startStop = [NSString stringWithFormat:@"%d", 1];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToWatch"]];
        
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
        
        [self stopAction];
        
        //Envia o 2 pra informar o watch que o stop foi selecionado
        NSString *startStop = [NSString stringWithFormat:@"%d", 2];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToWatch"]];
        
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
}

- (void)startAction{
    
    //Set notification
    [self setNotification];
    
    // Store startDate
    [database setStartDate:[NSDate date] toStep:currentStep];
    [defaults setInteger:0 forKey:@"avgHeartRate"];
    
    stepStarted = TRUE;
    [defaults setBool:stepStarted forKey:@"stepStarted"];
 
    //Timer pra acontecer a animacao
    //[_endStep setImage:[UIImage imageNamed:@"relogio"] forState: nil];
    
    [self.endStep rotation360:3 option: UIViewAnimationOptionAllowUserInteraction];
    timerAnimation = [NSTimer scheduledTimerWithTimeInterval:3
                                                      target:self
                                                    selector:@selector(animationButton)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopAction{
    // Store endDate and avgHeartRate
    [database setEndDate:[NSDate date] toStep:currentStep];
    float avgHeartRate = [defaults floatForKey:@"avgHeartRate"];
    [database setAvgHeartRate:avgHeartRate toStep:currentStep];
    
    stepStarted = FALSE;
    [defaults setBool:stepStarted forKey:@"stepStarted"];
    [timerAnimation invalidate];
    
    [self cancelNotification];
    
    // Show next step - store number and fetch next step
    // If there are still steps
    if (stepNumber < 3){
        stepNumber++;
        [self.circleView rotation: 1.0 option:0];
        [self updateStep];
        [defaults setInteger:stepNumber forKey:@"currentStepNumber"];
        [defaults setObject:currentStep.tag forKey:@"currentStepTag"];
        //[defaults synchronize];
    }
    // Final step ended
    else {
        [defaults setInteger:0 forKey:@"currentStepNumber"];
        [self showPopup:_confirmPopupView];
    }
}

- (void)updateStep {
    currentStep = [database fetchStep:(stepNumber-1) forGoalID:goalID];
    _labelStep.text = currentStep.name;
    // update goal and tag too
    _goalLabel.text = [[defaults stringForKey:@"goalName"] uppercaseString];
    _tagLabel.text = [defaults stringForKey:@"currentStepTag"];
    
    if (stepStarted) {
        NSLog(@"Step has already started");
        
        //Timer pra acontecer a animacao
        [self.endStep rotation360:3 option: UIViewAnimationOptionAllowUserInteraction];
        timerAnimation = [NSTimer scheduledTimerWithTimeInterval:3
                                                          target:self
                                                        selector:@selector(animationButton)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void)animationButton{
    [self.endStep rotation360:3 option: UIViewAnimationOptionAllowUserInteraction];
}

- (void)updateCircleRotation {
    if (stepNumber == 2) {
        [self.circleView rotation: 1.0 option:0];
    } else if (stepNumber == 3) {
        [self.circleView rotation: 1.0 option:0];
        [self.circleView rotation: 1.0 option:0];
    }
}

- (IBAction)startRelax:(UIButton *)sender {
    if (stepStarted) {
        [self showPopup:_relaxPopupView];
    }
    else {
        [self performSegueWithIdentifier:@"currentToRelax" sender:self];
    }
}

- (IBAction)justRelax:(UIButton *)sender {
    // sem medir o batimento
    [self closePopup];
    [self performSegueWithIdentifier:@"currentToRelax" sender:self];
}

- (IBAction)relaxAndMeasure:(UIButton *)sender {
    selectHeart = true;
    [self closePopup];
    [self showPopup:_tutorialPopupView];
}

- (IBAction)goToRelax:(UIButton *)sender {
    [self closePopup];
    // medindo o batimento
    [self performSegueWithIdentifier:@"currentToRelax" sender:self];
}

- (IBAction)clickOutsidePopup:(UITapGestureRecognizer *)sender {
    selectHeart = false;
    
    if (currentPopup != _confirmPopupView) {
        [self closePopup];
    }
}

- (void)showPopup:(UIView *)popupView {
    currentPopup = popupView;
    
    popupView.hidden = false;
    _blurBackground.hidden = false;
    
    [UIView animateWithDuration:0.7 animations:^{
        [_blurBackground setAlpha:1.0];
        [popupView setAlpha:0.95];
    }];
}

- (void)closePopup {
    [UIView animateWithDuration:0.7 animations:^{
        if (!selectHeart || currentPopup == _tutorialPopupView) {
            [_blurBackground setAlpha:0.0];
        }
        
        [currentPopup setAlpha:0.0];
    }];
    
    currentPopup.hidden = true;
}

- (void)setNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
    localNotification.alertBody = [NSString stringWithFormat: @"Você ainda não terminou o passo %ld", (long)stepNumber];
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow: 12];
    localNotification.repeatInterval = NSCalendarUnitDay;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}


-(void)cancelNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"currentToRelax"]) {
        RelaxViewController *d = (RelaxViewController *)segue.destinationViewController;
        d.selectHeartRate = selectHeart;
    
    }
    
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id>* )message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {

        if ([message[@"callCurrent"]  isEqual: @1]) {
            
            //Envia o texto do step
            //NSString *startStopText = [NSString stringWithFormat:@"%@", _labelStep.text];
            NSArray * steps = [database fetchStepsForGoalID:goalID];
            
            for (int i=0; i<steps.count; i++){
                stepsWatch = steps[i];
                [stepsText addObject: stepsWatch.name];
                NSLog(@"%@",stepsText[i]);
            }
            
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[stepsText[0], stepsText[1], stepsText[2] ] forKeys:@[@"textToWatch0", @"textToWatch1", @"textToWatch2"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                           NSLog(@"Deu erro");
                                       }
             ];

        }else if ([message[@"callStep"]  isEqual: @1]) {
        
          int value = 0;
          
          if (!stepStarted){
              if (stepNumber == 1){
                  value = 10;
              }else if (stepNumber == 2){
                  value = 20;
              }else if (stepNumber == 3){
                  value = 30;
              }
          }else{
              if (stepNumber == 1){
                  value = 11;
              }else if (stepNumber == 2){
                  value = 21;
              }else if (stepNumber == 3){
                  value = 31;
              }else if (stepNumber == 0){
                  value = 40; //Fim
              }
          }
          
          
          NSString *startStop = [NSString stringWithFormat:@"%d", value];
          NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"callStepValue"]];
          
          [[WCSession defaultSession] sendMessage:applicationData
                                     replyHandler:^(NSDictionary *reply) {
                                         //handle reply from iPhone app here
                                     }
                                     errorHandler:^(NSError *error) {
                                         //catch any errors here
                                         NSLog(@"Deu erro - 23");
                                     }
           ];
   
          
      }else{
          
          NSString *counterValue = [message objectForKey:@"startStopToIphone"];
          NSLog(@"RESULTADO %@",counterValue);
          
          if ([counterValue integerValue] == 2){
              [self startAction];
          }else if ([counterValue integerValue] == 1){
              [self stopAction];
          }
          
      }
    
}

#pragma mark - Watch communication
/*
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    //Handling different message types
    if (message[@"saveActivity"] != nil) {
        
        Activity *chosenActivity = [NSKeyedUnarchiver unarchiveObjectWithData:message[@"saveActivity"]];
        
        
        //TODO: Properly handle error, forbidding user from requesting suggestions on watch
 
        
        [self monitorRegion:chosenActivity];
        
    } else {
        
        CLLocation *loc = [CLLocation alloc];
        
        //if watch series 2 is being used
        if (![message[@"Coordinates"]  isEqual: @[@0, @0]]) {
            NSNumber *latitude = message[@"Coordinates"][0];
            NSNumber *longitude = message[@"Coordinates"][1];
            loc = [loc initWithLatitude:[latitude doubleValue] longitude: [longitude doubleValue]];
            
        } else {
            
            
            //[locationManager requestAlwaysAuthorization];
            loc = [self.locationManager location];
            NSLog(@"lat: %f long:%f", loc.coordinate.latitude, loc.coordinate.longitude);
        }
        
        NSMutableArray *activities = [[NSMutableArray<Activity*> alloc] init];
        
        [[PlacesProviderSingleton sharedInstance] FindPlacesWithCoordinates:loc completionHandler:^(NSArray<Location *> *places, NSError *error) {
            for(Location* place in places){
                Activity* act = [[Activity alloc] initWithBadHabit:nil Place:place];
                [activities addObject:act];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activities];
            NSData *locData = [NSKeyedArchiver archivedDataWithRootObject:loc];
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            response[@"Activities"] = data;
            response[@"Location"] = locData;
            replyHandler(response);
            
        }];
    }
 
}*/

@end
