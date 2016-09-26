//
//  EndViewController.m
//  FicaFrio
//
//  Created by Bárbara Souza on 25/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "EndViewController.h"

@interface EndViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageStep;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *tagText;

@end

@implementation EndViewController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



