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
}
@property (weak, nonatomic) IBOutlet UIImageView *step1;
@property (weak, nonatomic) IBOutlet UIImageView *step2;
@property (weak, nonatomic) IBOutlet UIImageView *step3;
@property (weak, nonatomic) IBOutlet UIImageView *center;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleGoal;
@property (weak, nonatomic) IBOutlet UILabel *bpm;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bpmValue;
@property (strong, nonatomic) IBOutlet UIView *min;
@property (weak, nonatomic) IBOutlet UILabel *minValue;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;

- (IBAction)animate:(id)sender;
- (IBAction)heart:(id)sender;
- (IBAction)timer:(id)sender;

-(void)selectGraf: (int)valueOne value2: (int)valueTwo value3: (int)valueThree;

@end

@implementation GoalFeedbackViewController

int direction= 1;
int shakes = 47;
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
    
    _step1.hidden = YES;
    _step2.hidden = YES;
    _step3.hidden = YES;
    if(flag){
        [_center setImage:[UIImage imageNamed:@"relogio_2"]];
        flag = NO;
    }else{
        [_center setImage:[UIImage imageNamed:@"coracao_2"]];
        flag = YES;
    }
    [_center addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:0 nextImege:_step1];
    [_step1 addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:0.5 nextImege:_step2];
    [_step2 addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:1.0 nextImege:_step3];
    [_step3 addSubviewWithZoomInAnimation:0.5 option:UIViewAnimationOptionCurveEaseIn delay:1.5 nextImege:nil];

    //Chamada de func que monta o grafico
    [self selectGraf: [[avgRate objectAtIndex: 0] intValue] value2: [[avgRate objectAtIndex: 1] intValue] value3: [[avgRate objectAtIndex: 2] intValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animate:(id)sender {
    [self animateAction];
}

- (IBAction)heart:(id)sender {
    printf("%d",34);
    if (!flag){
        [self animateAction];
    }else{
        [self shake:_heartButton];
    }
}

- (IBAction)timer:(id)sender {
    if (flag){
        [self animateAction];
    }else{
        [self shake:_timerButton];
    }
}

-(void)animateAction{
    _step1.hidden = YES;
    _step2.hidden = YES;
    _step3.hidden = YES;
    if(flag){
        [_center setImage:[UIImage imageNamed:@"relogio_2"]];
        [self selectGraf: [[time objectAtIndex: 0] intValue] value2: [[time objectAtIndex: 1] intValue] value3: [[time objectAtIndex: 2] intValue]];
        _titleGoal.text = [NSLocalizedString(@"Time", "") uppercaseString];
        flag = NO;
    }else{
        [_center setImage:[UIImage imageNamed:@"coracao_2"]];
        [self selectGraf: [[avgRate objectAtIndex: 0] intValue] value2: [[avgRate objectAtIndex: 1] intValue] value3: [[avgRate objectAtIndex: 2] intValue]];
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
    [UIView animateWithDuration:0.03 animations:^ {
        theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
    }
                     completion:^(BOOL finished){
                         if(shakes >= 10) {
                             theOneYouWannaShake.transform = CGAffineTransformIdentity;
                             return;
                         }
                         shakes++;
                         direction = direction * -1;
                         [self shake:theOneYouWannaShake];
                     }];
}



//Func que escolhe o tamnho da imagem de cada estapa a partir dos valores recebidos
//Ainda tem que fazer os casos de valores iguais
-(void)selectGraf: (int)valueOne value2: (int)valueTwo value3: (int)valueThree{
    NSLog(@"one: %d two: %d three: %d", valueOne, valueTwo, valueThree);
    
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
    
    
    if ((valueOne > valueTwo) && (valueOne > valueThree)){
        [_step1 setImage:[UIImage imageNamed:@"Roda_g_superior"]];
        if(valueTwo > valueThree){
            NSLog(@"two: %d > three: %d", valueTwo, valueThree);
            [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
            [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];

        }else if(valueTwo < valueThree){
            NSLog(@"two: %d < three: %d", valueTwo, valueThree);
            [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
            [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];

        }else {
            NSLog(@"two: %d = three: %d", valueTwo, valueThree);
            [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
            [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
        }
    }else if((valueTwo > valueOne) && (valueTwo > valueThree)){
        [_step2 setImage:[UIImage imageNamed:@"Roda_g_direita"]];
        if(valueOne > valueThree){
            NSLog(@"one: %d > three: %d", valueOne, valueThree);
            [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
            [_step3 setImage:[UIImage imageNamed:@"Roda_p_esquerda"]];
            
        }else if(valueOne < valueThree){
            NSLog(@"one: %d < three: %d", valueOne, valueThree);
            [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
            [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
        }else {
            NSLog(@"one: %d = three: %d", valueOne, valueThree);
            [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
            [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
        }
    }else if((valueThree > valueOne) && (valueThree > valueTwo)){
        [_step3 setImage:[UIImage imageNamed:@"Roda_g_esquerda"]];
        if(valueOne > valueTwo){
            NSLog(@"one: %d > two: %d", valueOne, valueTwo);
            [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
            [_step2 setImage:[UIImage imageNamed:@"Roda_p_direita"]];
            
        }else if(valueOne < valueTwo) {
            NSLog(@"one: %d < two: %d", valueOne, valueTwo);
            [_step1 setImage:[UIImage imageNamed:@"Roda_p_superior"]];
            [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
        }else {
            NSLog(@"one: %d = two: %d", valueOne, valueTwo);
            [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
            [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
        }
    }else{
        [_step1 setImage:[UIImage imageNamed:@"Roda_m_superior"]];
        [_step2 setImage:[UIImage imageNamed:@"Roda_m_direita"]];
        [_step3 setImage:[UIImage imageNamed:@"Roda_m_esquerda"]];
    }
}

- (IBAction)back:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
