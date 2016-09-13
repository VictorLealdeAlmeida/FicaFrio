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
//- (void) changeNumber;
- (IBAction)newGoal:(id)sender;

@end


@implementation CurrentStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //numberStep = 1;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    // Get current step
    goalID = [defaults stringForKey:@"currentGoalID"];
    stepNumber = [defaults integerForKey:@"currentStepNumber"];
    NSLog(@"currentStep: %@", goalID);
    [self updateStep];
    
//    NSArray *steps;
//    steps = [NSArray arrayWithObjects: @") contrário do que se acredita, Lorem Ipsum não é simplesmente um texto randômico. Com mais de 2000 anos", @"Because we used the NSArray class in the above example the contents of the array object cannot be changed subsequent to initialization.", @"The objects contained in an array are given index positions beginning at position zero. Each element may be accessed by passing the required index position through as an argument to the NSArray objectAtIndex", @"Yellow", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGoal:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)circleButton:(id)sender {
    [self endStep];
}

// When start button is clicked
- (void)startStep {
    // Change button image to "stop" image
    
    // Store startDate
    [database setStartDate:[NSDate date] toStep:currentStep];
}

- (void)updateStep {
    NSLog(@"entered updateStep");
    currentStep = [database fetchStep:(stepNumber-1) forGoalID:goalID];
    _labelStep.text = currentStep.name;
    _circleNumber.text = [NSString stringWithFormat: @"%ld", (long)stepNumber];
}

- (void)endStep {
    // Store endDate
    [database setEndDate:[NSDate date] toStep:currentStep];
    // Show next step - store number and fetch next step
    // If there are steps still
    if (stepNumber < 3){
        stepNumber++;
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