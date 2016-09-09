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
- (IBAction)circleTap:(id)sender;

@end

@implementation SetStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)circleTap:(id)sender {
    
    [self.circleView rotation: 1.0 option:0];
    
}


@end