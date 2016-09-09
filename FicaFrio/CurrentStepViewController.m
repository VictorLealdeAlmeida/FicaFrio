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
- (IBAction)circleButton:(id)sender;

@end

@implementation CurrentStepViewController

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

@end