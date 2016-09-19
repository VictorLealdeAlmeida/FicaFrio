//
//  CurrentStepViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//


#import "CurrentStepViewController.h"
#import "FicaFrio-Swift.h"
#import "Step.h"
#import "BD.h"
#import "FicaFrio-Swift.h"

@interface CurrentStepViewController () {
    BD *database;
    NSUserDefaults *defaults;
    NSInteger stepNumber;
    NSString *goalID;
    Step *currentStep;
    NSDate *dateTime;
    NSTimer *timerAnimation;
    bool selectHeart;
    bool stepStarted;
    UIImageView *imageView;
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
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;
@property (weak, nonatomic) IBOutlet UILabel *measureLabel;



//Actions popup
- (IBAction)circleButton:(id)sender;
- (IBAction)newGoal:(id)sender;
- (IBAction)startStep:(id)sender;
- (IBAction)startRelax:(UIButton *)sender;
- (IBAction)justRelax:(UIButton *)sender;
- (IBAction)relaxAndMeasure:(UIButton *)sender;
- (IBAction)goToRelax:(UIButton *)sender;

@end


@implementation CurrentStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _startStep.hidden = false;
    _endStep.hidden = true;
    
    _tutorialLabel.text = NSLocalizedString(@"Para medir seus batimentos, encoste a ponta do indicador na sua câmera:", "");
    _measureLabel.text = NSLocalizedString(@"Deseja medir seus batimentos enquanto respira?", "");
    
    _backLabel.text = NSLocalizedString(@"Nova Meta", @"");
    _infoLabel.text = NSLocalizedString(@"Avaliação da Tarefa", @"");
    _grafLabel.text = NSLocalizedString(@"Avaliação Geral", @"");
    
    selectHeart = false;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    // Get current step (goal and number)
    goalID = [defaults stringForKey:@"currentGoalID"];
    stepNumber = [defaults integerForKey:@"currentStepNumber"];
    stepStarted = [defaults boolForKey:@"stepStarted"];
    
    
    [self updateStep];
    [self updateCircleRotation];
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
    
    [defaults setBool:TRUE forKey:@"stepStarted"];
    //[defaults synchronize];

    //Timer pra acontecer a animacao
    [self.endStep rotation360:3 option: UIViewAnimationOptionAllowUserInteraction];
    timerAnimation = [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(animationButton)
                                   userInfo:nil
                                    repeats:YES];
    

}

- (void)animationButton{
    [self.endStep rotation360:3 option: UIViewAnimationOptionAllowUserInteraction];
}

// endStep - When end button is clicked
- (IBAction)circleButton:(id)sender {
    // Store endDate
    [database setEndDate:[NSDate date] toStep:currentStep];
    
    [defaults setBool:FALSE forKey:@"stepStarted"];
    [timerAnimation invalidate];
    
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
        [defaults setInteger:0 forKey:@"currentStepNumber"];
        [self showPopup];
    }
}

- (void)updateStep {
    currentStep = [database fetchStep:(stepNumber-1) forGoalID:goalID];
    _labelStep.text = currentStep.name;
    // update goal and tag too
    _goalLabel.text = [defaults stringForKey:@"goalName"];
    _tagLabel.text = [defaults stringForKey:@"currentStepTag"];
    
    if (stepStarted) {
        NSLog(@"Step has already started");
        _startStep.hidden = true;
        _endStep.hidden = false;
        
        //Timer pra acontecer a animacao
        [self.endStep rotation360:3 option: UIViewAnimationOptionAllowUserInteraction];
        timerAnimation = [NSTimer scheduledTimerWithTimeInterval:3
                                                          target:self
                                                        selector:@selector(animationButton)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void)updateCircleRotation {
    if (stepNumber == 2) {
        [self.circleView rotation: 1.0 option:0];
    } else if (stepNumber == 3) {
        [self.circleView rotation: 1.0 option:0];
        [self.circleView rotation: 1.0 option:0];
    }
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
    [self closePopup:_relaxPopupView];
    // sem medir o batimento
    selectHeart = false;
    [self performSegueWithIdentifier:@"currentToRelax" sender:self];
}

- (IBAction)relaxAndMeasure:(UIButton *)sender {
    [self closePopup:_relaxPopupView];
    [self showPopup:_tutorialPopupView];
}

- (IBAction)goToRelax:(UIButton *)sender {
    [self closePopup:_tutorialPopupView];
    // medindo o batimento
    selectHeart = true;
    [self performSegueWithIdentifier:@"currentToRelax" sender:self];
}

- (void)showPopup:(UIView *)popupView {
    popupView.hidden = false;
    _darkView.hidden = false;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.55];
    [popupView setAlpha:0.95];
    [UIView commitAnimations];
    
    if (popupView == _tutorialPopupView) {
        NSLog(@"gif should appear");
        UIImage *logoGif = [UIImage gifImageWithName:@"Gif_Heart_Rate"];
        //UIImageView *imageView = [[UIImageView alloc] setImage:logoGif];
        imageView = [[UIImageView alloc] initWithImage:logoGif];
        CGRect frame = CGRectMake(self.view.frame.size.width/2 - imageView.frame.size.width/13, self.view.frame.size.height/3 + imageView.frame.size.height/8, imageView.frame.size.width/6.5, imageView.frame.size.height/6.5);
        [imageView setFrame:frame];
        [self.view addSubview:imageView];
    }
}

- (void)closePopup:(UIView *)popupView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    //[_darkView setAlpha:0.0];
    [popupView setAlpha:0.0];
    [UIView commitAnimations];
    
    if (popupView == _tutorialPopupView) {
        [imageView removeFromSuperview];
    }
    
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    _darkView.hidden = true;
    if ([segue.identifier isEqualToString:@"currentToRelax"]) {
        RelaxViewController *d = (RelaxViewController *)segue.destinationViewController;
        d.selectHeartHate = selectHeart;
    
    }
    
}

@end
