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
@end

@implementation GoalFeedbackViewController

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

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animate:(id)sender {
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
@end