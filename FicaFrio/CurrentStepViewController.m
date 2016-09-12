//
//  CurrentStepViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 06/09/16.
//  Copyright © 2016 Victor Leal Porto de Almeida Arruda. All rights reserved.
//


#import "CurrentStepViewController.h"

@interface CurrentStepViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *circleNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelStep;

//Popup
@property (weak, nonatomic) IBOutlet UIView *containerPopup;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPopup;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *grafButton;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *grafLabel;

- (IBAction)circleButton:(id)sender;
- (void) changeNumber;


@end


@implementation CurrentStepViewController

int numberStep = 1;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *steps;
    steps = [NSArray arrayWithObjects: @") contrário do que se acredita, Lorem Ipsum não é simplesmente um texto randômico. Com mais de 2000 anos", @"Because we used the NSArray class in the above example the contents of the array object cannot be changed subsequent to initialization.", @"The objects contained in an array are given index positions beginning at position zero. Each element may be accessed by passing the required index position through as an argument to the NSArray objectAtIndex", @"Yellow", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)circleButton:(id)sender {

    [self changeNumber];
    _labelStep.text = [NSString stringWithFormat: @"%s", "steps[1]"];

}

- (void) changeNumber{
    if (numberStep <= 2){
        numberStep++;
        [self.circleView rotation: 1.0 option:0];
        _circleNumber.text = [NSString stringWithFormat: @"%d", numberStep];
    }else{
        _containerPopup.hidden = false;
        numberStep = 1;
    }
  
}


@end