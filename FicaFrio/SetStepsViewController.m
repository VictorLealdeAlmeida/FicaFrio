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
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *viewButton;

- (IBAction)Back:(id)sender;
- (IBAction)circleTap:(id)sender;
- (IBAction)nextStep:(id)sender;
- (void)changeNumber;
- (void)actionCircle;

@end

@implementation SetStepsViewController

int number = 1;

- (void)viewDidLoad {
    [super viewDidLoad];

    number = 1;
    
    //Pra descer o teclado
    [_textStep setDelegate:self];
    
    //Formatando o TextFild
    _textStep.layer.cornerRadius = 10.0f;
    _textStep.layer.masksToBounds = YES;

    
    _viewButton.layer.cornerRadius = 10.0f;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)circleTap:(id)sender {
    if (![_textStep.text  isEqual: @""]){
        [self actionCircle];
    }
}

- (IBAction)nextStep:(id)sender {
    if (![_textStep.text  isEqual: @""]){
        [self actionCircle];
    }
}

- (void)actionCircle{
    
    _textStep.text = @"";
    [self.view endEditing:YES];
    
    if (number < 3){
        [self changeNumber];
        [self.circleView rotation: 1.0 option:0];
        if (number == 3){
            [_buttonNext setTitle:@"GO!" forState:UIControlStateNormal];
        }
    }else{
        [self performSegueWithIdentifier:@"SetToCurrent" sender:nil];
    }
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