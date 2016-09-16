//
//  SetStepsViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "SetStepsViewController.h"
#import "Step.h"
#import "BD.h"

@interface SetStepsViewController () {
    int direction;
    int shakes;
    int number;
    int tagNumber;
    NSMutableArray *stepsNames;
    NSMutableArray *stepsTags;
    NSArray *tags;
    BD *database;
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *viewButton; // ? shakes
@property (weak, nonatomic) IBOutlet UITextField *stepNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrow; // ? shakes
@property (weak, nonatomic) IBOutlet UIButton *setStepsButton;
@property (weak, nonatomic) IBOutlet UIView *darkView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

//@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (weak, nonatomic) IBOutlet UIButton *setStepButton;

// Tag-related outlets
@property (weak, nonatomic) IBOutlet UIImageView *tagPopupView;
@property (weak, nonatomic) IBOutlet UILabel *pickTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagOneButton;
@property (weak, nonatomic) IBOutlet UIButton *tagTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *tagThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *tagFourButton;
@property (weak, nonatomic) IBOutlet UIButton *tagFiveButton;
//@property (weak, nonatomic) IBOutlet UILabel *stepTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *stepTagButton;



- (IBAction)goToNextStep:(UIButton *)sender;

- (IBAction)circleRight:(id)sender;
- (IBAction)circleLeft:(id)sender;
- (IBAction)goToNextScreen:(UIButton *)sender;

//- (IBAction)pickTag:(id)sender;
- (IBAction)setTagOne:(UIButton *)sender;
- (IBAction)setTagTwo:(UIButton *)sender;
- (IBAction)setTagThree:(UIButton *)sender;
- (IBAction)setTagFour:(UIButton *)sender;
- (IBAction)setTagFive:(UIButton *)sender;
- (IBAction)closeViewTag:(id)sender;
- (IBAction)changeTag:(UIButton *)sender;


@end

@implementation SetStepsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _setStepsButton.hidden = true;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    stepsNames = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    stepsTags = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    tags = @[NSLocalizedString(@"Autoexposição", ""), NSLocalizedString(@"Estudos", ""), NSLocalizedString(@"Trabalho", ""), NSLocalizedString(@"Interação Social", ""), NSLocalizedString(@"Outros", "")];
    
    _descriptionLabel.text = NSLocalizedString(@"Divida sua meta em três passos e não esqueça de escolher uma tag para cada um deles!", "");
    _stepNameTextField.placeholder = NSLocalizedString(@"Digite sua tarefa", "");
    
    _goalLabel.text = [defaults stringForKey:@"goalName"];
    
    number = 1;
    direction= 1;
    shakes = 55;

    [_stepNameTextField setDelegate:self];
    
    // Sets para fazer o shake no textfield
    [self shake:_stepNameTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Funcao que limita o numero de caracteres no textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 140;
}

// Check step button
- (IBAction)goToNextStep:(UIButton *)sender {
    if ([self.view endEditing:YES]) { // Force end editing
        [self checkIfCanGoToNextStep];
    }
}

- (void)checkIfCanGoToNextStep {
    if ([self checkIfCanFinish]) {
        // Go back to step one
        if (number == 2) { [self rotateCircleToLeft]; }
        else if (number == 3) { [self rotateCircleToRight]; }
    }
    else {
        if(![_stepNameTextField.text isEqual:@""] && ![[stepsTags objectAtIndex:(number-1)] isEqual:@""]) {
            [self rotateCircleToRight];
        } else if (![_stepNameTextField.text isEqual:@""]){
            [self.view endEditing:YES]; // Force end editing
            [self showTagPopup];
        }
        else {
            [self shake:_stepNameTextField];
            [self shake:_viewButton];
            [self shake:_arrow];
        }
    }
}

- (BOOL)checkIfCanFinish {
    // If all steps names and tags are set, show button to complete
    if (![stepsNames containsObject:@""] && ![stepsTags containsObject:@""]) {
        NSLog(@"all steps are set");
        _setStepsButton.hidden = false;
        return true;
    }
    return false;
}

// Go on to next screen, saving current goal with its steps names and tags
- (IBAction)goToNextScreen:(UIButton *)sender {
    [self addGoal];
    [self performSegueWithIdentifier:@"SetToCurrent" sender:nil];
}

- (void) addGoal {
    NSString* goalName = @"placeholder goal";
    NSString* goalID = [[NSUUID UUID] UUIDString];
    [defaults setObject:goalID forKey:@"currentGoalID"];
    [defaults setInteger:1 forKey:@"currentStepNumber"];
    [defaults setObject:[stepsTags objectAtIndex:0] forKey:@"currentStepTag"];
    //[defaults synchronize];
    [database createNewGoal:goalName withSteps:stepsNames tags:stepsTags andID:goalID];
}

// Tag-related ----------------------------------------------------

//- (IBAction)pickTag:(id)sender {
//    [self.view endEditing:YES]; // Force end editing
//    [self showTagPopup];
//}

- (IBAction)setTagOne:(UIButton *)sender {
    tagNumber = 1;
    [self closeTagPopup];
}

- (IBAction)setTagTwo:(UIButton *)sender {
    tagNumber = 2;
    [self closeTagPopup];
}

- (IBAction)setTagThree:(UIButton *)sender {
    tagNumber = 3;
    [self closeTagPopup];
}

- (IBAction)setTagFour:(UIButton *)sender {
    tagNumber = 4;
    [self closeTagPopup];
}

- (IBAction)setTagFive:(UIButton *)sender {
    tagNumber = 5;
    [self closeTagPopup];
}

- (IBAction)closeViewTag:(id)sender {
    tagNumber = 5;
    [self closeTagPopup];
}

- (IBAction)changeTag:(UIButton *)sender {
    [self showTagPopup];
}

// ----------------------------------------------------------------

// Rotation-related -----------------------------------------------
- (IBAction)circleRight:(id)sender {
    //[self.view endEditing:YES]; // Force end editing
    [self rotateCircleToRight];
}

- (IBAction)circleLeft:(id)sender {
    //[self.view endEditing:YES]; // Force end editing
    [self rotateCircleToLeft];
}

- (void)rotateCircleToRight {
    [self incrementNumber];
    [self updateStepText];
    [self.circleView rotation: 1.0 option:0];
}

- (void)rotateCircleToLeft {
    [self decrementNumber];
    [self updateStepText];
    [self.circleView rotationOpposite: 1.0 option:0];
}
// ----------------------------------------------------------------

// Update texts and its colors ------------------------------------
- (void)updateStepText {
    _stepNameTextField.text = [stepsNames objectAtIndex:(number-1)];
    _stepNumberLabel.text = [NSString stringWithFormat:@"%d", number];
    //_stepTagLabel.text = [stepsTags objectAtIndex:(number-1)];
    [_stepTagButton setTitle:[stepsTags objectAtIndex:(number-1)] forState:UIControlStateNormal];
    [self matchTextColorToStep];
}

// Matches color of text of labels inside the circle (number and tag)
- (void)matchTextColorToStep {
    UIColor *textColor;
    if (number == 1){
        textColor = [UIColor colorWithRed:0.78 green:0.89 blue:0.91 alpha:1.0];
    }else if(number == 2){
        textColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.82 alpha:1.0];
    }else if(number == 3){
        textColor = [UIColor colorWithRed:0.27 green:0.45 blue:0.58 alpha:1.0];
    }
    _stepNumberLabel.textColor = textColor;
    //_stepTagLabel.textColor = textColor;]
    [_stepTagButton setTitleColor:textColor forState:UIControlStateNormal];
}
// ----------------------------------------------------------------

- (void)incrementNumber{
    if (number < 3) {number++;}
    else {number = 1;}
}

- (void)decrementNumber{
    if (number > 1) {number--;}
    else {number = 3;}
}

// UITextField Delegates ----------------------------------------------
// When return is clicked, end editing
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"text field should return");
    [self.view endEditing:YES]; // Force end editing
    return YES;
}

// Hides the keyboard, saves current step name and checks if can go to next step
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"text field did end editing");
    [stepsNames replaceObjectAtIndex:(number-1) withObject:_stepNameTextField.text];
    [self checkIfCanGoToNextStep];
}
// --------------------------------------------------------------------

// Shake UIView passed as parameter
- (void)shake:(UIView *)theOneYouWannaShake {
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

// Arredondar as bordas do TextField
- (void)viewWillLayoutSubviews {
    _stepNameTextField.layer.cornerRadius = 10.0f;
    _stepNameTextField.layer.masksToBounds = YES;
    
    UIGraphicsBeginImageContextWithOptions(_viewButton.bounds.size, NO, 0);
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:_viewButton.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(20, 20)
                              ];
    [maskPath fill];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _viewButton.bounds;
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    maskLayer.contents = (id)result.CGImage;
    maskLayer.path = maskPath.CGPath;
    
    _viewButton.layer.mask = maskLayer;
}

// Choosing tags -----------------------------------------------------
- (void) showTagPopup{
    // Show all the popup elements
    
    _pickTagLabel.text = NSLocalizedString(@"ESCOLHA UMA CATEGORIA", "");
    [_tagOneButton setTitle:tags[0] forState:UIControlStateNormal];
    [_tagTwoButton setTitle:tags[1] forState:UIControlStateNormal];
    [_tagThreeButton setTitle:tags[2] forState:UIControlStateNormal];
    [_tagFourButton setTitle:tags[3] forState:UIControlStateNormal];
    [_tagFiveButton setTitle:tags[4] forState:UIControlStateNormal];
    
    
    _darkView.hidden = false;
    _tagPopupView.hidden = false;
    _pickTagLabel.hidden = false;
    _tagOneButton.hidden = false;
    _tagTwoButton.hidden = false;
    _tagThreeButton.hidden = false;
    _tagFourButton.hidden = false;
    _tagFiveButton.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.55];
    [_tagPopupView setAlpha:0.95];
    [_pickTagLabel setAlpha:0.95];
    [_tagOneButton setAlpha:0.95];
    [_tagTwoButton setAlpha:0.95];
    [_tagThreeButton setAlpha:0.95];
    [_tagFourButton setAlpha:0.95];
    [_tagFiveButton setAlpha:0.95];
    [UIView commitAnimations];
}

- (void) closeTagPopup{
    [stepsTags replaceObjectAtIndex:(number-1) withObject:[tags objectAtIndex:(tagNumber-1)]];
    [self updateStepText];
    //_stepTagLabel.hidden = false;
    _stepTagButton.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.0];
    [_tagPopupView setAlpha:0.0];
    [_pickTagLabel setAlpha:0.0];
    [_tagOneButton setAlpha:0.0];
    [_tagTwoButton setAlpha:0.0];
    [_tagThreeButton setAlpha:0.0];
    [_tagFourButton setAlpha:0.0];
    [_tagFiveButton setAlpha:0.0];
    [UIView commitAnimations];
    
    //Timer pra acontecer a animacao antes do hidden
    [NSTimer scheduledTimerWithTimeInterval:0.7
                                     target:self
                                   selector:@selector(closeTagPopupHidden)
                                   userInfo:nil
                                    repeats:NO];
    

    
    [self checkIfCanGoToNextStep];
}

- (void) closeTagPopupHidden{
    // Hide all the popup elements
    _darkView.hidden = true;
    _tagPopupView.hidden = true;
    _pickTagLabel.hidden = true;
    _tagOneButton.hidden = true;
    _tagTwoButton.hidden = true;
    _tagThreeButton.hidden = true;
    _tagFourButton.hidden = true;
    _tagFiveButton.hidden = true;
}
// --------------------------------------------------------------------

@end
