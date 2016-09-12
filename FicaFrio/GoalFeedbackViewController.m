//
//  GoalFeedbackViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "GoalFeedbackViewController.h"

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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animate:(id)sender {
}
@end