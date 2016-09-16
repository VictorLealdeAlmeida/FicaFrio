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
}
@property (weak, nonatomic) IBOutlet UIImageView *step1;
@property (weak, nonatomic) IBOutlet UIImageView *step2;
@property (weak, nonatomic) IBOutlet UIImageView *step3;
@property (weak, nonatomic) IBOutlet UIImageView *center;
@property (weak, nonatomic) IBOutlet UILabel *titleGoal;
@property (weak, nonatomic) IBOutlet UILabel *bpm;
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

BOOL flag; //Denife qual infomaçao está sendo mostrada no grafico
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Pegar dados do banco
    database = [BD new];
    defaults = [NSUserDefaults standardUserDefaults];
    goalID = [defaults stringForKey:@"goalID"];
    goalSteps = [database fetchStepsForGoalID:goalID];
    
    for (int i = 0; i < goalSteps.count; i++){
        Step *step = [goalSteps objectAtIndex:i];
        //step.avgHeartRate  - média de batimentos do passo i
        //step.duration      - duração do passo i
    }
    // ---------------------
    
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
    [self selectGraf:1 value2:4 value3:3];
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
        flag = NO;
    }else{
        [_center setImage:[UIImage imageNamed:@"coracao_2"]];
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
   
    if ((valueOne > valueTwo) && (valueOne > valueThree)){
        [_step1 setImage:[UIImage imageNamed:@"topo_01"]];
        if(valueTwo > valueThree){
            [_step2 setImage:[UIImage imageNamed:@"direita_02"]];
            [_step3 setImage:[UIImage imageNamed:@"esquerda_03"]];

        }else{
            [_step2 setImage:[UIImage imageNamed:@"direita_03"]];
            [_step3 setImage:[UIImage imageNamed:@"esquerda_02"]];

        }
    }else if((valueTwo > valueOne) && (valueTwo > valueThree)){
        [_step3 setImage:[UIImage imageNamed:@"esquerda_01"]];
        if(valueOne > valueThree){
            [_step1 setImage:[UIImage imageNamed:@"topo_02"]];
            [_step2 setImage:[UIImage imageNamed:@"direita_03"]];
            
        }else{
            [_step1 setImage:[UIImage imageNamed:@"topo_03"]];
            [_step2 setImage:[UIImage imageNamed:@"direita_02"]];
        }
    }else if((valueThree > valueOne) && (valueThree > valueTwo)){
        [_step2 setImage:[UIImage imageNamed:@"direita_01"]];
        if(valueOne > valueTwo){
            [_step1 setImage:[UIImage imageNamed:@"topo_02"]];
            [_step3 setImage:[UIImage imageNamed:@"esquerda_03"]];
            
        }else{
            [_step1 setImage:[UIImage imageNamed:@"topo_03"]];
            [_step3 setImage:[UIImage imageNamed:@"esquerda_02"]];
        }
    }
}

@end
