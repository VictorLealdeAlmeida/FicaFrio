//
//  CurrentStepViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//


#import "CurrentStepViewController.h"

@interface CurrentStepViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *circleNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelStep;

//Popup
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPopup;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *grafButton;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *grafLabel;

//Actions popup


- (IBAction)circleButton:(id)sender;
- (void) changeNumber;
- (IBAction)newGoal:(id)sender;


@end


@implementation CurrentStepViewController

int numberStep = 1;

//Motion popup


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *steps;
    steps = [NSArray arrayWithObjects: @") contrário do que se acredita, Lorem Ipsum não é simplesmente um texto randômico. Com mais de 2000 anos", @"Because we used the NSArray class in the above example the contents of the array object cannot be changed subsequent to initialization.", @"The objects contained in an array are given index positions beginning at position zero. Each element may be accessed by passing the required index position through as an argument to the NSArray objectAtIndex", @"Yellow", nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGoal:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)circleButton:(id)sender {

    [self changeNumber];
    _labelStep.text = [NSString stringWithFormat: @"%s", "steps[1]"];

}

- (void) changeNumber{
    if (numberStep <= 2){
        numberStep++;
        [self.circleView rotation: 1.0 option:0];
        _circleNumber.text = [NSString stringWithFormat: @"%d", numberStep];
    }else{
        [self showPopup];
 
        numberStep = 1;
    }
  
}

- (void) showPopup{
    _backgroundPopup.hidden = false;
    _backButton.hidden = false;
    _infoButton.hidden = false;
    _grafButton.hidden = false;
    _backLabel.hidden = false;
    _infoLabel.hidden = false;
    _grafLabel.hidden = false;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_backgroundPopup setAlpha:0.95];
    [_backButton setAlpha:0.95];
    [_infoButton setAlpha:0.95];
    [_grafButton setAlpha:0.95];
    [_backLabel setAlpha:0.95];
    [_infoLabel setAlpha:0.95];
    [_grafLabel setAlpha:0.95];
    [UIView commitAnimations];
}


@end