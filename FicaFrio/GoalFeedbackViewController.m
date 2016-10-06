//
//  GoalFeedbackViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "GoalFeedbackViewController.h"
#import "Animation.m"
#import "BD.h"

@interface GoalFeedbackViewController () {
    BD *database;
    NSUserDefaults *defaults;
    NSString *goalID;
    NSArray *goalSteps;
    NSMutableArray *time;
    NSMutableArray *avgRate;
    long timeRange;
    long rateRange;
    Step *step;
    int maxRateStep;
    int maxTimeStep;
}
@property (weak, nonatomic) IBOutlet UIImageView *step1;
@property (weak, nonatomic) IBOutlet UIImageView *step2;
@property (weak, nonatomic) IBOutlet UIImageView *step3;
@property (weak, nonatomic) IBOutlet UIImageView *center;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleGoal;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UILabel *bpm;
@property (weak, nonatomic) IBOutlet UILabel *bpmValue;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UILabel *min;
@property (weak, nonatomic) IBOutlet UILabel *minValue;

- (IBAction)animate:(id)sender;
- (IBAction)heart:(id)sender;
- (IBAction)timer:(id)sender;
- (IBAction)back:(id)sender;

-(void)selectGraf: (int)valueOne value2: (int)valueTwo value3: (int)valueThree;

@end

@implementation GoalFeedbackViewController

BOOL flag; //Define qual infomaçao está sendo mostrada no grafico
double media;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = NSLocalizedString(@"Goal Feedback", "");
    
    // Pegar dados do banco
    time = [NSMutableArray array];
    avgRate = [NSMutableArray array];
    database = [BD new];
    defaults = [NSUserDefaults standardUserDefaults];
    goalID = [defaults stringForKey:@"currentGoalID"];
    goalSteps = [database fetchStepsForGoalID:goalID];
    
    timeRange = 0;
    rateRange = 0;
    int zeros = 0;
    
    for (int i = 0; i < goalSteps.count; i++){
        step = goalSteps[i];
        [time addObject: step.duration];
        [avgRate addObject: step.avgHeartRate];
        timeRange = timeRange + [step.duration integerValue];
        if ([step.avgHeartRate integerValue] == 0) {
            zeros++;
            NSLog(@"%d", zeros);
        }
        rateRange = rateRange + [step.avgHeartRate integerValue];
        NSLog(@"time range: %ld and rate range: %ld", timeRange, rateRange);
        //step.avgHeartRate  - média de batimentos do passo i
        //step.duration      - duração do passo i
    }
    media = ((int)timeRange/3)/60; // timeRange em segundos
    _minValue.text = [[NSNumber numberWithDouble:media] stringValue];
    if(zeros < 3){
        media = (int)rateRange/(3-zeros);
    }else{
        media = 0;
    }
    _bpmValue.text = [[NSNumber numberWithDouble:media] stringValue];
    _titleGoal.text = [NSLocalizedString(@"Heart Rate", "") uppercaseString];
    
    flag = NO;
    [self animateAction];

    //Chamada de func que monta o grafico
    [self selectGraf: [[avgRate objectAtIndex: 0] intValue] value2: [[avgRate objectAtIndex: 1] intValue] value3: [[avgRate objectAtIndex: 2] intValue]];
    
    [self adjustMaxColors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animate:(id)sender {
    [self animateAction];
}

- (IBAction)heart:(id)sender {
    if (!flag){
        [self animateAction];
    }else{
        [self shake:_center];
    }
}

- (IBAction)timer:(id)sender {
    if (flag){
        [self animateAction];
    }else{
        [self shake:_center];
    }
}

-(void)animateAction{
    _step1.hidden = YES;
    _step2.hidden = YES;
    _step3.hidden = YES;
    if(flag){
        [self selectGraf: [[time objectAtIndex: 0] intValue] value2: [[time objectAtIndex: 1] intValue] value3: [[time objectAtIndex: 2] intValue]];
        [_center setImage:[UIImage imageNamed:[NSString stringWithFormat:@"relogio_%d", maxTimeStep]]];
        _titleGoal.text = [NSLocalizedString(@"Time", "") uppercaseString];
        flag = NO;
    }else{
        [self selectGraf: [[avgRate objectAtIndex: 0] intValue] value2: [[avgRate objectAtIndex: 1] intValue] value3: [[avgRate objectAtIndex: 2] intValue]];
        [_center setImage:[UIImage imageNamed:[NSString stringWithFormat:@"coracao_%d", maxRateStep]]];
        _titleGoal.text = [NSLocalizedString(@"Heart Rate", "") uppercaseString];
        flag = YES;
    }
    [_center addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:0 nextImege:_step1];
    [_step1 addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:0.5 nextImege:_step2];
    [_step2 addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:1.0 nextImege:_step3];
    [_step3 addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:1.5 nextImege:nil];
}

// Shake UIView passed as parameter
- (void)shake:(UIView *)theOneYouWannaShake{
    NSTimeInterval duration = 0.08;
    CGFloat translation = 5;
    
    [UIView
     animateWithDuration:duration
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^ {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(translation, 0);
     }
     completion:^(BOOL finished){
         
         [UIView
          animateWithDuration:duration
          delay:0.0
          options:UIViewAnimationOptionCurveEaseInOut
          animations:^ {
              theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(-translation, 0);
          }
          completion:^(BOOL finished){
         
              [UIView
               animateWithDuration:1.3*duration
               delay:0.0
               options:UIViewAnimationOptionCurveEaseInOut
               animations:^ {
                   theOneYouWannaShake.transform = CGAffineTransformIdentity;
               }
               completion:^(BOOL finished){
               }];
          }];
     }];
}



//Func que escolhe o tamnho da imagem de cada estapa a partir dos valores recebidos
//Ainda tem que fazer os casos de valores iguais
-(void)selectGraf: (int)valueOne value2: (int)valueTwo value3: (int)valueThree{
    //NSLog(@"one: %d two: %d three: %d", valueOne, valueTwo, valueThree);
    
    if ((valueOne == valueTwo) && (valueOne == valueThree) && (valueTwo == valueThree)) {
        // All values are equal
        [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
        [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
        [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
    }
    else if ((valueOne != valueTwo) && (valueOne != valueThree) && (valueTwo != valueThree)) {
        // All values are different
        if ((valueOne > valueTwo) && (valueOne > valueThree)){
            
            [_step1 setImage:[UIImage imageNamed:@"Roda_g_superior"]];
            if(valueTwo > valueThree){
                NSLog(@"two: %d > three: %d", valueTwo, valueThree);
                [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];
                
            }else {
                NSLog(@"two: %d < three: %d", valueTwo, valueThree);
                [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
                
            }
        }else if((valueTwo > valueOne) && (valueTwo > valueThree)){
            [_step2 setImage:[UIImage imageNamed:@"Roda_g_direita"]];
            if(valueOne > valueThree){
                NSLog(@"one: %d > three: %d", valueOne, valueThree);
                [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];
                
            }else {
                NSLog(@"one: %d < three: %d", valueOne, valueThree);
                [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
            }
        }else if((valueThree > valueOne) && (valueThree > valueTwo)){
            [_step3 setImage:[UIImage imageNamed:@"Roda_g_esquerda"]];
            if(valueOne > valueTwo){
                NSLog(@"one: %d > two: %d", valueOne, valueTwo);
                [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
                
            }else {
                NSLog(@"one: %d < two: %d", valueOne, valueTwo);
                [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
            }
        }
    }
    else {
        // Only one value is different
        if(valueOne == valueTwo) {
            if (valueOne > valueThree){
                [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];
            } else {
                [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
            }
        } else if (valueOne == valueThree){
            if (valueOne > valueTwo){
                [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
            } else {
                [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];
            }
        } else if (valueTwo == valueThree){
            if (valueTwo > valueOne){
                [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
            } else {
                [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
                [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
                [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];
            }
        }
    }
}

-(void)adjustMaxColors {
    NSNumber *maxRate = [avgRate valueForKeyPath:@"@max.intValue"];
    NSUInteger maxRateIndex = [avgRate indexOfObject:maxRate];
    maxRateStep = (int)maxRateIndex + 1;
    [self adjustTextColorOf:@"heart rate" toStep:maxRateStep];
    
    NSNumber *maxTime = [time valueForKeyPath:@"@max.intValue"];
    NSUInteger maxTimeIndex = [time indexOfObject:maxTime];
    maxTimeStep = (int)maxTimeIndex + 1;
    [self adjustTextColorOf:@"time" toStep:maxTimeStep];
}

- (void)adjustTextColorOf:(NSString*)type toStep:(NSUInteger)maxStepNumber {
    UIColor *textColor;
    NSLog(@"%@: %lu", type, (unsigned long)maxStepNumber);
    if (maxStepNumber == 1){
        textColor = [UIColor colorWithRed:0.78 green:0.89 blue:0.91 alpha:1.0];
    }else if(maxStepNumber == 2){
        textColor = [UIColor colorWithRed:72.0/255.0 green:187.0/255.0 blue:199.0/255.0 alpha:1.0];
    }else if(maxStepNumber == 3){
        textColor = [UIColor colorWithRed:0.27 green:0.45 blue:0.58 alpha:1.0];
    }
    
    if ([type  isEqual: @"heart rate"]){
        [_heartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"coracao_%lu", (unsigned long)maxStepNumber]] forState:UIControlStateNormal];
        _bpm.textColor = textColor;
        _bpmValue.textColor = textColor;
        [_center setImage:[UIImage imageNamed:[NSString stringWithFormat:@"coracao_%lu", (unsigned long)maxStepNumber]]];
    } else if ([type  isEqual: @"time"]){
        [_timerButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"relogio_%lu", (unsigned long)maxStepNumber]] forState:UIControlStateNormal];
        _min.textColor = textColor;
        _minValue.textColor = textColor;
    }
}


- (IBAction)back:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
