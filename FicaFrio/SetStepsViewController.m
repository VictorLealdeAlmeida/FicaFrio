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

@interface SetStepsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *stepNumber;
@property (weak, nonatomic) IBOutlet UITextField *textStep;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;


- (IBAction)nextStep:(id)sender;
- (void)changeNumber;

- (void)rotateCircleToRight;
- (IBAction)circleRigth:(id)sender;
- (IBAction)circleLeft:(id)sender;

@end

@implementation SetStepsViewController

int direction= 1;
int shakes = 55;
int number = 1;
NSMutableArray *stepsNames;
NSMutableArray *stepsTags;
BD *database;
NSUserDefaults *defaults;


- (void)viewDidLoad {
    [super viewDidLoad];

    //database
    defaults = [NSUserDefaults standardUserDefaults];
    database = [BD new];
    stepsNames = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    
    number = 1;
    
    //Pra descer o teclado
    [_textStep setDelegate:self];
    
    //Formatando o TextField
    [self radiusView];
    
    //Sets para fazer o shake no textfield
    [self shake:_textStep];
}

// Skip to next step
- (void)skipStep {
    // If user wrote Step: store it, iterate number and rotate circle to next step
    if (![_textStep.text  isEqual: @""]){
        NSLog(@"%d", number);
        [stepsNames replaceObjectAtIndex:(number-1) withObject:_textStep.text];
        NSLog(@"%@", stepsNames);
        [self changeNumber];
        [self rotateCircleToRight];
    }
    // If user didn't write step, shake all
    else {
        [self shake:_textStep];
        [self shake:_viewButton];
        [self shake:_arrow];
    }
}

- (void) addGoal {
    NSString* goalName = @"placehoader goal";
    NSString* goalID = [[NSUUID UUID] UUIDString];
    [defaults setObject:goalID forKey:@"currentGoalID"];
    [database createNewGoal:goalName withSteps:stepsNames tags:stepsTags andID:goalID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Rotaciona o círculo
- (void)rotateCircleToRight{
    //_textStep.text = [stepsNames objectAtIndex:(number-1)];
    [self updateStepText];
    [self.view endEditing:YES];
    
    if (number <= 3){
        //[self changeNumber];
        [self.circleView rotation: 1.0 option:0];
        if (number == 3){
            [_buttonNext setTitle:@"GO!" forState:UIControlStateNormal];
        }
    }else{
        [self performSegueWithIdentifier:@"SetToCurrent" sender:nil];
    }
}

- (IBAction)nextStep:(id)sender {
        [self skipStep];
}

- (IBAction)circleRigth:(id)sender {
    [self skipStep];
}

// Atualiza o texto no TextField, o número na roda e sua cor
- (void)updateStepText {
    _textStep.text = [stepsNames objectAtIndex:(number-1)];
    _stepNumber.text = [NSString stringWithFormat:@"%d", number];
    [self changeNumberColor: number];
}

- (IBAction)circleLeft:(id)sender {
    if (number == 1){
        // Limite inferior
        [self shake:_circleView];
        [self shake:_stepNumber];
    }else if (number == 2){
        number = 1;
        [self updateStepText];
        [self.circleView rotationOpposite: 1.0 option:0];
        
    }else if (number == 3){
        number = 2;
        [self updateStepText];
        [_buttonNext setTitle:@"NEXT" forState:UIControlStateNormal];
        [self.circleView rotationOpposite: 1.0 option:0];
    }
}

- (void)changeNumberColor:(int)value{
    if (value == 1){
        _stepNumber.textColor = [UIColor colorWithRed:0.78 green:0.89 blue:0.91 alpha:1.0];
    }else if(value == 2){
        _stepNumber.textColor = [UIColor colorWithRed:0.51 green:0.77 blue:0.82 alpha:1.0];
    }else if(value == 3){
        _stepNumber.textColor = [UIColor colorWithRed:0.27 green:0.45 blue:0.58 alpha:1.0];
    }
}

- (void)changeNumber{
    if (number < 3){
        number++;
    }else{
        number = 1;
    }
    
    //_stepNumber.text = [NSString stringWithFormat: @"%d", number];
    //[self changeNumberColor: number];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)shake:(UIView *)theOneYouWannaShake{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
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

@end