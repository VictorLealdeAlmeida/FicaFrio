//
//  SetStepsViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//

#import "SetStepsViewController.h"

@interface SetStepsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *stepNumber;
@property (weak, nonatomic) IBOutlet UITextField *textStep;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;


- (IBAction)nextStep:(id)sender;
- (void)changeNumber;

- (void)actionCircle;
- (IBAction)circleRigth:(id)sender;
- (IBAction)circleLeft:(id)sender;

@end

@implementation SetStepsViewController

int direction;
int shakes;
int number = 1;

- (void)viewDidLoad {
    [super viewDidLoad];

    number = 1;
    
    //Pra descer o teclado
    [_textStep setDelegate:self];
    
    //Formatando o TextFild
    [self radiusView];
    
    //Sets para fazer o shake no textfild
    direction = 1;
    shakes = 55;
    [self shake:_textStep];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





   // printf("%d",21331);
    //NSLog(@"%d",value);


- (IBAction)nextStep:(id)sender {
    if (![_textStep.text  isEqual: @""]){
        [self actionCircle];
    }else{
        [self shake:_textStep];
        [self shake:_viewButton];
        [self shake:_arrow];
    }
}

- (void)actionCircle{
    
    _textStep.text = @"";
    [self.view endEditing:YES];
    
    if (number < 3){
        [self changeNumber];
        [self.circleView rotation: 1.0 option:0];
        if (number == 3){
            [_buttonNext setTitle:@"GO!" forState:UIControlStateNormal];
        }
    }else{
        [self performSegueWithIdentifier:@"SetToCurrent" sender:nil];
    }
    
}

- (IBAction)circleRigth:(id)sender {
    if (![_textStep.text  isEqual: @""]){
        [self actionCircle];
    }else{
        [self shake:_textStep];
        [self shake:_viewButton];
        [self shake:_arrow];
    }
}

- (IBAction)circleLeft:(id)sender {
    if (number == 1){
        [self shake:_circleView];
        [self shake:_stepNumber];

    }else if (number == 2){
        number = 1;
        _stepNumber.text = @"1";
        [self changeNumberColor: number];
        [self.circleView rotationOpposite: 1.0 option:0];
        
    }else if (number == 3){
        number = 2;
        _stepNumber.text = @"2";
        [_buttonNext setTitle:@"NEXT" forState:UIControlStateNormal];
        [self changeNumberColor: number];
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
    if (number <= 2){
        number++;
    }else{
        number = 1;
    }
    
    _stepNumber.text = [NSString stringWithFormat: @"%d", number];
    [self changeNumberColor: number];

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
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}

@end