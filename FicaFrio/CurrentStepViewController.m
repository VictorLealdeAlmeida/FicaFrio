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

- (IBAction)circleButton:(id)sender;
- (void) changeNumber;

@end

@implementation CurrentStepViewController

int numberStep = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)circleButton:(id)sender {
    [self.circleView rotation: 1.0 option:0];
}

- (void) changeNumber{
    if (numberStep <= 2){
        numberStep++;
    }else{
        numberStep = 1;
    }
    _circleNumber.text = [NSString stringWithFormat: @"%d", numberStep];
}


@end