//
//  GoalFeedbackViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "GoalFeedbackViewController.h"
#import "Animation.m"

@interface GoalFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *step1;
@property (weak, nonatomic) IBOutlet UIImageView *step2;
@property (weak, nonatomic) IBOutlet UIImageView *step3;
@property (weak, nonatomic) IBOutlet UIImageView *center;
@property (weak, nonatomic) IBOutlet UILabel *titleGoal;
@property (weak, nonatomic) IBOutlet UILabel *bpm;
@property (weak, nonatomic) IBOutlet UIImageView *bpmImage;
@property (weak, nonatomic) IBOutlet UILabel *bpmValue;
@property (strong, nonatomic) IBOutlet UIView *min;
@property (weak, nonatomic) IBOutlet UIImageView *minImage;
@property (weak, nonatomic) IBOutlet UILabel *minValue;

- (IBAction)animate:(id)sender;
- (IBAction)heart:(id)sender;
- (IBAction)timer:(id)sender;
-(void)selectGraf: (int)valueOne value2: (int)valueTwo value3: (int)valueThree;

@end

@implementation GoalFeedbackViewController

int direction= 1;
int shakes = 55;

BOOL flag; //Denife qual infomaçao está sendo mostrada no grafico
- (void)viewDidLoad {
    [super viewDidLoad];
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

    [self selectGraf:3 value2:2 value3:1];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animate:(id)sender {
    [self animateAction];
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

- (IBAction)heart:(id)sender{
    if (flag){
        [self animateAction];
    }else{
        [self shake:_bpmImage];
    }
}

- (IBAction)timer:(id)sender{
    if (!flag){
        [self animateAction];
    }else{
        [self shake:_minImage];
    }
}

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
        [_step2 setImage:[UIImage imageNamed:@"esquerda_01"]];
        if(valueOne > valueThree){
            [_step1 setImage:[UIImage imageNamed:@"topo_02"]];
            [_step3 setImage:[UIImage imageNamed:@"direita_03"]];
            
        }else{
            [_step1 setImage:[UIImage imageNamed:@"topo_03"]];
            [_step3 setImage:[UIImage imageNamed:@"direita_02"]];
        }
    }else if((valueTwo > valueOne) && (valueTwo > valueThree)){
        [_step3 setImage:[UIImage imageNamed:@"direita_01"]];
        if(valueOne > valueTwo){
            [_step1 setImage:[UIImage imageNamed:@"topo_02"]];
            [_step2 setImage:[UIImage imageNamed:@"esquerda_03"]];
            
        }else{
            [_step1 setImage:[UIImage imageNamed:@"topo_03"]];
            [_step2 setImage:[UIImage imageNamed:@"esquerda_02"]];
        }
    }
}

@end
