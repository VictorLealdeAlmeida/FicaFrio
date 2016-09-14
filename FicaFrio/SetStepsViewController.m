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
    NSMutableArray *stepsNames;
    NSMutableArray *stepsTags;
    BD *database;
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *stepNumber;
@property (weak, nonatomic) IBOutlet UITextField *textStep;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *setStepsButton;

@property (weak, nonatomic) IBOutlet UIImageView *tagPopup;
@property (weak, nonatomic) IBOutlet UILabel *pickTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagOne;
@property (weak, nonatomic) IBOutlet UILabel *tagTwo;
@property (weak, nonatomic) IBOutlet UILabel *tagThree;
@property (weak, nonatomic) IBOutlet UILabel *tagFour;
@property (weak, nonatomic) IBOutlet UILabel *tagFive;


- (IBAction)nextStep:(id)sender;
- (void)rotateCircleToRight;
- (void)rotateCircleToLeft;
- (IBAction)circleRight:(id)sender;
- (IBAction)circleLeft:(id)sender;
- (IBAction)setSteps:(id)sender;
- (IBAction)pickTag:(id)sender;

@end

@implementation SetStepsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _setStepsButton.hidden = true;
    
    // Database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    stepsNames = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    
    number = 1;
    direction= 1;
    shakes = 55;
    
    // To hide keyboard
    [_textStep setDelegate:self];
    
    // Formatando o TextField
    [self radiusView];
    
    //Sets para fazer o shake no textfield
    [self shake:_textStep];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) addGoal {
    NSString* goalName = @"placeholder goal";
    NSString* goalID = [[NSUUID UUID] UUIDString];
    [defaults setObject:goalID forKey:@"currentGoalID"];
    [defaults setInteger:1 forKey:@"currentStepNumber"];
    [defaults synchronize];
    [database createNewGoal:goalName withSteps:stepsNames tags:stepsTags andID:goalID];
}

// Check step button: saves steps and rotates right
- (IBAction)nextStep:(id)sender {
    [self.view endEditing:YES]; // Hide keyboard
    
    if ([self saveStep]) {
        // Rotate circle to right if the step was saved and isn't the last one filled
        [self rotateCircleToRight];
    }
    // If all steps are set, show button to complete
    if (![stepsNames containsObject:@""]) {
        NSLog(@"all steps are set");
        _setStepsButton.hidden = false;
    }
}

- (BOOL)saveStep {
    // If user wrote step name, store it at stepsNames
    if(![_textStep.text  isEqual: @""]){
        [stepsNames replaceObjectAtIndex:(number-1) withObject:_textStep.text];
        // If it's the last step to be filled, return false to avoid rotation
        if (![stepsNames containsObject:@""]){
            return false;
        }
        return true;
    }
    // If user didn't write step, shake all and return false
    else {
        [self shake:_textStep];
        [self shake:_viewButton];
        [self shake:_arrow];
        return false;
    }
}

- (IBAction)circleRight:(id)sender {
    [self.view endEditing:YES]; // Hide keyboard
    [self rotateCircleToRight];
}

- (IBAction)circleLeft:(id)sender {
    [self.view endEditing:YES]; // Hide keyboard
    [self rotateCircleToLeft];
}

- (IBAction)setSteps:(id)sender {
    [self addGoal];
    [self performSegueWithIdentifier:@"SetToCurrent" sender:nil];
}

- (IBAction)pickTag:(id)sender {
    [self showTagPopup];
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

// Updates texts and color
- (void)updateStepText {
    _textStep.text = [stepsNames objectAtIndex:(number-1)];
    _stepNumber.text = [NSString stringWithFormat:@"%d", number];
    [self changeNumberColor];
}

- (void)changeNumberColor{
    if (number == 1){
        _stepNumber.textColor = [UIColor colorWithRed:0.78 green:0.89 blue:0.91 alpha:1.0];
    }else if(number == 2){
        _stepNumber.textColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.82 alpha:1.0];
    }else if(number == 3){
        _stepNumber.textColor = [UIColor colorWithRed:0.27 green:0.45 blue:0.58 alpha:1.0];
    }
}

- (void)incrementNumber{
    if (number < 3) {number++;}
    else {number = 1;}
}

- (void)decrementNumber{
    if (number > 1) {number--;}
    else {number = 3;}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// Shake UIView passed as parameter
- (void)shake:(UIView *)theOneYouWannaShake{
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

// Escolha de tags
- (void) showTagPopup{
    _tagPopup.hidden = false;
    _pickTagLabel.hidden = false;
    _tagOne.hidden = false;
    _tagTwo.hidden = false;
    _tagThree.hidden = false;
    _tagFour.hidden = false;
    _tagFive.hidden = false;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [_tagPopup setAlpha:0.95];
    [_pickTagLabel setAlpha:0.95];
    [_tagOne setAlpha:0.95];
    [_tagTwo setAlpha:0.95];
    [_tagThree setAlpha:0.95];
    [_tagFour setAlpha:0.95];
    [_tagFive setAlpha:0.95];
    [UIView commitAnimations];
}

@end
