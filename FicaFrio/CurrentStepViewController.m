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
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;


//Popup
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPopup;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *grafButton;
@property (weak, nonatomic) IBOutlet UILabel *backLabel; // Nova Meta
@property (weak, nonatomic) IBOutlet UILabel *infoLabel; // Avaliação da Tarefa
@property (weak, nonatomic) IBOutlet UILabel *grafLabel; // Avaliação Geral
@property (weak, nonatomic) IBOutlet UIView *darkView;


@property (weak, nonatomic) IBOutlet UIView *relaxPopupView;
@property (weak, nonatomic) IBOutlet UIView *tutorialPopupView;




//Actions popup
- (IBAction)circleButton:(id)sender;
//- (void) changeNumber;
- (IBAction)newGoal:(id)sender;
- (IBAction)startStep:(id)sender;
- (IBAction)startRelax:(UIButton *)sender;
- (IBAction)justRelax:(UIButton *)sender;
- (IBAction)relaxAndMeasure:(UIButton *)sender;
- (IBAction)goToRelax:(UIButton *)sender;


@end


@implementation CurrentStepViewController

NSDate *dateTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    _startStep.hidden = false;
    _endStep.hidden = true;
    
    _backLabel.text = NSLocalizedString(@"Nova Meta", @"");
    _infoLabel.text = NSLocalizedString(@"Avaliação da Tarefa", @"");
    _grafLabel.text = NSLocalizedString(@"Avaliação Geral", @"");
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    // Get current step (goal and number)
    goalID = [defaults stringForKey:@"currentGoalID"];
    stepNumber = [defaults integerForKey:@"currentStepNumber"];
    
    [self updateStep];
    [self setNotification];

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

// endStep - When end button is clicked
- (IBAction)circleButton:(id)sender {
    // Store endDate
    [database setEndDate:[NSDate date] toStep:currentStep];
    // Show next step - store number and fetch next step
    // If there are still steps
    if (stepNumber < 3){
        stepNumber++;
        _startStep.hidden = false;
        _endStep.hidden = true;
        [self.circleView rotation: 1.0 option:0];
        [self updateStep];
        [defaults setInteger:stepNumber forKey:@"currentStepNumber"];
        [defaults setObject:currentStep.tag forKey:@"currentStepTag"];
        //[defaults synchronize];
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
    // update goal and tag too
    _goalLabel.text = [defaults stringForKey:@"goalName"];
    _tagLabel.text = [defaults stringForKey:@"currentStepTag"];
    NSLog(@"%@", [defaults stringForKey:@"currentStepTag"]);
}

- (void) showPopup{
    _darkView.hidden = false;
    _backgroundPopup.hidden = false;
    _backButton.hidden = false;
    _infoButton.hidden = false;
    _grafButton.hidden = false;
    _backLabel.hidden = false;
    _infoLabel.hidden = false;
    _grafLabel.hidden = false;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.55];
    [_backgroundPopup setAlpha:0.95];
    [_backButton setAlpha:0.95];
    [_infoButton setAlpha:0.95];
    [_grafButton setAlpha:0.95];
    [_backLabel setAlpha:0.95];
    [_infoLabel setAlpha:0.95];
    [_grafLabel setAlpha:0.95];
    [UIView commitAnimations];
}

- (IBAction)startRelax:(UIButton *)sender {
    [self showPopup:_relaxPopupView];
}

- (IBAction)justRelax:(UIButton *)sender {
    [self performSegueWithIdentifier:@"currentToRelax" sender:self];
    // sem medir o batimento
}

- (IBAction)relaxAndMeasure:(UIButton *)sender {
    [self closePopup:_relaxPopupView];
    [self showPopup:_tutorialPopupView];
}

- (IBAction)goToRelax:(UIButton *)sender {
    [self performSegueWithIdentifier:@"currentToRelax" sender:self];
    // medindo o batimento
}

- (void)showPopup:(UIView *)popupView {
    popupView.hidden = false;
    _darkView.hidden = false;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.55];
    [popupView setAlpha:0.95];
    [UIView commitAnimations];
}

- (void)closePopup:(UIView *)popupView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    //[_darkView setAlpha:0.0];
    [popupView setAlpha:0.0];
    [UIView commitAnimations];
    
    //Timer pra acontecer a animacao antes do hidden
    [NSTimer scheduledTimerWithTimeInterval:0.7
                                     target:self
                                   selector:@selector(closeTagPopupHidden)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) closeTagPopupHidden {
    // Hide all the popup elements
    //_darkView.hidden = true;
    _relaxPopupView.hidden = true;
    //_tutorialPopupView.hidden = true;
    
}


- (IBAction)datePicker:(UIDatePicker *)sender {
    dateTime = sender.date;
}

- (void)setNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
    localNotification.alertBody = @"Bora pegar";
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
   // localNotification.repeatInterval = 5;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

@end
