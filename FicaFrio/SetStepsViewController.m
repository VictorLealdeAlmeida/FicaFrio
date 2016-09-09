//
//  SetStepsViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "SetStepsViewController.h"

@interface SetStepsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *stepNumber;
@property (weak, nonatomic) IBOutlet UITextField *textStep;

- (IBAction)Back:(id)sender;
- (IBAction)circleTap:(id)sender;
- (void)changeNumber;


@end

@implementation SetStepsViewController

int number = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_textStep setDelegate:self];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)circleTap:(id)sender {
    [self changeNumber];
    [self.circleView rotation: 1.0 option:0];
}

- (void)changeNumber{
    if (number <= 2){
        number++;
    }else{
        number = 1;
    }
    _stepNumber.text = [NSString stringWithFormat: @"%d", number];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end