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
@property (weak, nonatomic) IBOutlet UILabel *stepNumber; // stepNumberLabel
@property (weak, nonatomic) IBOutlet UITextField *textStep; // stepNameTextField
@property (weak, nonatomic) IBOutlet UIButton *buttonNext; // DELETAR
@property (weak, nonatomic) IBOutlet UIView *viewButton; // ? shakes
@property (weak, nonatomic) IBOutlet UIImageView *arrow; // ? shakes
@property (weak, nonatomic) IBOutlet UIButton *setStepsButton; // setAllStepsButton ou confirmStepsButton
@property (weak, nonatomic) IBOutlet UIView *darkView;

// Tag-related outlets
@property (weak, nonatomic) IBOutlet UIImageView *tagPopup; // tagPopupView
@property (weak, nonatomic) IBOutlet UILabel *pickTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagOneButton;
@property (weak, nonatomic) IBOutlet UIButton *tagTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *tagThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *tagFourButton;
@property (weak, nonatomic) IBOutlet UIButton *tagFiveButton;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel; // stepTagLabel

- (IBAction)nextStep:(id)sender; // goToNextStep
- (IBAction)circleRight:(id)sender; // rotateRight
- (IBAction)circleLeft:(id)sender; // rotateLeft
- (IBAction)setSteps:(id)sender; // goToNextScreen ou setAllSteps ou confirmSteps
- (IBAction)pickTag:(id)sender; // chooseTag
- (IBAction)setTagOne:(UIButton *)sender;
- (IBAction)setTagTwo:(UIButton *)sender;
- (IBAction)setTagThree:(UIButton *)sender;
- (IBAction)setTagFour:(UIButton *)sender;
- (IBAction)setTagFive:(UIButton *)sender;
- (IBAction)closeViewTag:(id)sender;


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
    tags = @[@"Autoexposição", @"Estudos", @"Trabalho", @"Interação Social", @"Outros"];
    
    number = 1;
    direction= 1;
    shakes = 55;

    [_textStep setDelegate:self];
    
    // Formatando o TextField
    [self radiusView];
    
    // Sets para fazer o shake no textfield
    [self shake:_textStep];
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
- (IBAction)nextStep:(id)sender {
    if ([self.view endEditing:YES]) { // Force end editing
        [self checkIfCanGoToNextStep]; // If textField
        NSLog(@"GTBGFBGB");
    }
}

- (void)checkIfCanGoToNextStep {
    if ([self checkIfCanFinish]) {
        // Go back to step one
        if (number == 2) { [self rotateCircleToLeft]; }
        else if (number == 3) { [self rotateCircleToRight]; }
    }
    else {
        if(![_textStep.text isEqual:@""] && ![[stepsTags objectAtIndex:(number-1)] isEqual:@""]) {
            [self rotateCircleToRight];
        }
        else {
            [self shake:_textStep];
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
- (IBAction)setSteps:(id)sender {
    [self addGoal];
    [self performSegueWithIdentifier:@"SetToCurrent" sender:nil];
}

- (void) addGoal {
    NSString* goalName = @"placeholder goal";
    NSString* goalID = [[NSUUID UUID] UUIDString];
    [defaults setObject:goalID forKey:@"currentGoalID"];
    [defaults setInteger:1 forKey:@"currentStepNumber"];
    [defaults synchronize];
    [database createNewGoal:goalName withSteps:stepsNames tags:stepsTags andID:goalID];
}

// Tag-related ----------------------------------------------------
- (IBAction)pickTag:(id)sender {
    [self.view endEditing:YES]; // Force end editing
    [self showTagPopup];
}

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
// ----------------------------------------------------------------

// Rotation-related -----------------------------------------------
- (IBAction)circleRight:(id)sender {
    [self.view endEditing:YES]; // Force end editing
    [self rotateCircleToRight];
}

- (IBAction)circleLeft:(id)sender {
    [self.view endEditing:YES]; // Force end editing
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
    _textStep.text = [stepsNames objectAtIndex:(number-1)];
    _stepNumber.text = [NSString stringWithFormat:@"%d", number];
    _tagLabel.text = [stepsTags objectAtIndex:(number-1)];
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
    _stepNumber.textColor = textColor;
    _tagLabel.textColor = textColor;
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
    [stepsNames replaceObjectAtIndex:(number-1) withObject:_textStep.text];
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
- (void)radiusView {
    _textStep.layer.cornerRadius = 10.0f;
    _textStep.layer.masksToBounds = YES;
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:_viewButton.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(20, 20)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    //maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    _viewButton.layer.mask = maskLayer;
}

// Choosing tags -----------------------------------------------------
- (void) showTagPopup{
    // Show all the popup elements
    
    _darkView.hidden = false;
    _tagPopup.hidden = false;
    _pickTagLabel.hidden = false;
    _tagOneButton.hidden = false;
    _tagTwoButton.hidden = false;
    _tagThreeButton.hidden = false;
    _tagFourButton.hidden = false;
    _tagFiveButton.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.55];
    [_tagPopup setAlpha:0.95];
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
    _tagLabel.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_darkView setAlpha:0.0];
    [_tagPopup setAlpha:0.0];
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
    _tagPopup.hidden = true;
    _pickTagLabel.hidden = true;
    _tagOneButton.hidden = true;
    _tagTwoButton.hidden = true;
    _tagThreeButton.hidden = true;
    _tagFourButton.hidden = true;
    _tagFiveButton.hidden = true;
}
// --------------------------------------------------------------------

@end
