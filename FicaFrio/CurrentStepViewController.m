//
//  CurrentStepViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//


#import "CurrentStepViewController.h"
#import "Step.h"
#import "BD.h"

@interface CurrentStepViewController () {
    //int numberStep;
    BD *database;
    NSUserDefaults *defaults;
    NSInteger stepNumber;
    NSString *goalID;
    Step *currentStep;
}

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *labelStep;
@property (weak, nonatomic) IBOutlet UIButton *startStep;
@property (weak, nonatomic) IBOutlet UIButton *endStep;


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
//- (void) changeNumber;
- (IBAction)newGoal:(id)sender;
- (IBAction)startStep:(id)sender;


@end


@implementation CurrentStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _startStep.hidden = false;
    _endStep.hidden = true;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    // Get current step
    goalID = [defaults stringForKey:@"currentGoalID"];
    stepNumber = [defaults integerForKey:@"currentStepNumber"];
    NSLog(@"currentStep: %@", goalID);
    [self updateStep];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGoal:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// When start button is clicked
- (IBAction)startStep:(id)sender {
    _startStep.hidden = true;
    _endStep.hidden = false;
    
    // Store startDate
    [database setStartDate:[NSDate date] toStep:currentStep];
}

// endStep
- (IBAction)circleButton:(id)sender {
    // Store endDate
    [database setEndDate:[NSDate date] toStep:currentStep];
    // Show next step - store number and fetch next step
    // If there are steps still
    if (stepNumber < 3){
        stepNumber++;
        _startStep.hidden = false;
        _endStep.hidden = true;
        [self.circleView rotation: 1.0 option:0];
        [self updateStep];
        [defaults setInteger:stepNumber forKey:@"currentStepNumber"];
        [defaults synchronize];
    }
    // Final step ended
    else {
        [self showPopup];
    }
}

- (void)updateStep {
    NSLog(@"entered updateStep");
    currentStep = [database fetchStep:(stepNumber-1) forGoalID:goalID];
    _labelStep.text = currentStep.name;
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