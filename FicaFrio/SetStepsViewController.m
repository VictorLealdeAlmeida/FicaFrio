//
//  SetStepsViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "SetStepsViewController.h"
#import "BD.h"

@interface SetStepsViewController () {
    int direction;
    int shakes;
    int number;
    int tagNumber;
    NSMutableArray *stepsNames;
    NSMutableArray *stepsTags;
    NSMutableArray *stepsImages;
    NSArray *tags;
    BD *database;
    NSUserDefaults *defaults;
    //BOOL clickedOnce;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UITextField *stepNameTextField;
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *setStepButton;


@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *stepTagButton;

@property (weak, nonatomic) IBOutlet UIButton *setStepsButton;

// Tag popup-related outlets
@property (weak, nonatomic) IBOutlet UIView *tagsPopupView;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UILabel *pickTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagOneButton;
@property (weak, nonatomic) IBOutlet UIButton *tagTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *tagThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *tagFourButton;
@property (weak, nonatomic) IBOutlet UIButton *tagFiveButton;

- (IBAction)goToNextStep:(UIButton *)sender;

- (IBAction)circleRight:(id)sender;
- (IBAction)circleLeft:(id)sender;
- (IBAction)goToNextScreen:(UIButton *)sender;

- (IBAction)setTagOne:(UIButton *)sender;
- (IBAction)setTagTwo:(UIButton *)sender;
- (IBAction)setTagThree:(UIButton *)sender;
- (IBAction)setTagFour:(UIButton *)sender;
- (IBAction)setTagFive:(UIButton *)sender;
- (IBAction)closeViewTag:(id)sender;
- (IBAction)changeTag:(UIButton *)sender;

- (IBAction)dismissKeyboard:(UIControl *)sender;


@end

@implementation SetStepsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _setStepsButton.hidden = true;
    //clickedOnce = FALSE;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    
    stepsNames = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    stepsTags = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    //stepsImages = [NSMutableArray ]
    tags = @[NSLocalizedString(@"Self-exposure", ""), NSLocalizedString(@"Studies", ""), NSLocalizedString(@"Work", ""), NSLocalizedString(@"Social interaction", ""), NSLocalizedString(@"Others", "")];
    
    _titleLabel.text = NSLocalizedString(@"Steps", "");
    _goalLabel.text = [[defaults stringForKey:@"goalName"] uppercaseString];
    _descriptionLabel.text = NSLocalizedString(@"Break down your goal into three steps and don’t forget to pick a category for each!", "");
    _stepNameTextField.placeholder = NSLocalizedString(@"Type your task", "");

    [_stepNameTextField setDelegate:self];
    
    // Sets para fazer o shake no textfield
    number = 1;
    direction= 1;
    shakes = 55;
    [self shake:_stepNameTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// Confirm step and go to next
- (IBAction)goToNextStep:(UIButton *)sender {
    [self checkIfCanGoToNextStep];
}

//// Checks if the circle can rotate without losing text input
//- (BOOL)checkIfCanRotate {
//    [_stepNameTextField resignFirstResponder]; // Dismiss keyboard
//    
//    if (!clickedOnce && ![_stepNameTextField.text isEqual:[stepsNames objectAtIndex:(number-1)]]) {
//        // HIGHLIGHT BUTTON!!!
//        [_setStepButton setHighlighted:TRUE];
//        [self shake:_setStepButton];
//        [self shake:_setStepButton];
//        clickedOnce = TRUE;
//        return FALSE;
//    }
//    [_setStepButton setHighlighted:FALSE];
//    clickedOnce = FALSE;
//    return TRUE;
//}

// Checks if name and tag are set for current step
- (void)checkIfCanGoToNextStep {
    [_stepNameTextField resignFirstResponder]; // Dismiss keyboard
    
    // Save current step name
    [stepsNames replaceObjectAtIndex:(number-1) withObject:_stepNameTextField.text];
    
    // If all steps are set, rotate back to step one
    if ([self checkIfCanFinish]) {
        if (number == 2) { [self rotateCircleToLeft]; }
        else if (number == 3) { [self rotateCircleToRight]; }
    }
    // If there are still steps to be set
    else {
        // If name isn't set, shake textbox
        if ([[stepsNames objectAtIndex:(number-1)] isEqual:@""]) {
            [self shake:_stepNameTextField];
            [self shake:_viewButton];
            [self shake:_arrow];
        // If the step name is set...
        } else {
            // ... but the tag isn't
            if ([[stepsTags objectAtIndex:(number-1)] isEqual:@""]){
                [self showTagPopup];
            } else { // ... and the tag is also set, rotate to next step
                [[stepsImages objectAtIndex:(number-1)] setAlpha:1.0];
                [self rotateCircleToRight];
            }
        }
    }
}

// If all steps names and tags are set, shows button to confirm all
- (BOOL)checkIfCanFinish {
    if (![stepsNames containsObject:@""] && ![stepsTags containsObject:@""]) {
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
    NSString* goalID = [[NSUUID UUID] UUIDString];
    [defaults setObject:goalID forKey:@"currentGoalID"];
    [defaults setInteger:1 forKey:@"currentStepNumber"];
    //[defaults setObject:[stepsTags objectAtIndex:0] forKey:@"currentStepTag"];
    //[defaults synchronize];
    [database createNewGoal:[defaults stringForKey:@"goalName"] withSteps:stepsNames tags:stepsTags andID:goalID];
}

// Tag-related ----------------------------------------------------
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

// Clicking outside the popup
- (IBAction)closeViewTag:(id)sender {
    tagNumber = 5;
    [self closeTagPopup];
}

// Clicking on the current tag (to change it)
- (IBAction)changeTag:(UIButton *)sender {
    [self showTagPopup];
}

- (IBAction)dismissKeyboard:(UIControl *)sender {
    [_stepNameTextField resignFirstResponder];
}
// ----------------------------------------------------------------

// Rotation-related -----------------------------------------------
- (IBAction)circleRight:(id)sender {
    [_stepNameTextField resignFirstResponder]; // Dismiss keyboard
    [self rotateCircleToRight];
}

- (IBAction)circleLeft:(id)sender {
    [_stepNameTextField resignFirstResponder]; // Dismiss keyboard
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
    [_stepTagButton setTitle:[stepsTags objectAtIndex:(number-1)] forState:UIControlStateNormal];
    [self matchTextColorToStep];
    /*
    // Trocar imagem do passo atual pela sem número
    [[stepsImages objectAtIndex:(number-1)] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"passo%d_semnumero", number]]];
    // Trocar imagem dos outros passos pela com número
    [self incrementNumber];
    [[stepsImages objectAtIndex:(number-1)] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"passo%d_comnumero", number]]];
    [self decrementNumber];
    [[stepsImages objectAtIndex:(number-1)] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"passo%d_comnumero", number]]];
     */
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
// When return is clicked, check if can go to next step
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self checkIfCanGoToNextStep];
    return YES;
}

// Funcao que limita o numero de caracteres no textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    _setStepButton.enabled = TRUE;
    
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 140;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _setStepButton.enabled = FALSE;
    // Save current step name - to avoid losing step name alterations when rotating circle
    [stepsNames replaceObjectAtIndex:(number-1) withObject:_stepNameTextField.text];
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
    
    _pickTagLabel.text = NSLocalizedString(@"PICK A CATEGORY", "");
    [_tagOneButton setTitle:tags[0] forState:UIControlStateNormal];
    [_tagTwoButton setTitle:tags[1] forState:UIControlStateNormal];
    [_tagThreeButton setTitle:tags[2] forState:UIControlStateNormal];
    [_tagFourButton setTitle:tags[3] forState:UIControlStateNormal];
    [_tagFiveButton setTitle:tags[4] forState:UIControlStateNormal];
    
    _tagsPopupView.hidden = false;
    _darkView.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_tagsPopupView setAlpha:0.95];
    [_darkView setAlpha:0.55];
    [UIView commitAnimations];
}

- (void) closeTagPopup{
    [stepsTags replaceObjectAtIndex:(number-1) withObject:[tags objectAtIndex:(tagNumber-1)]];
    [self updateStepText];
    _stepTagButton.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_tagsPopupView setAlpha:0.0];
    [_darkView setAlpha:0.0];
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
    _tagsPopupView.hidden = true;
    _darkView.hidden = true;
}
// --------------------------------------------------------------------

@end
