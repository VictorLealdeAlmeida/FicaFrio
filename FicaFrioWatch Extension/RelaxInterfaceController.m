//
//  RelaxInterfaceController.m
//  FicaFrio
//
//  Created by Bárbara Souza on 21/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "RelaxInterfaceController.h"

@interface RelaxInterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *relaxImage;

@end

@implementation RelaxInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [_relaxImage setImageNamed:@"respirar"];
    [_relaxImage startAnimatingWithImagesInRange: NSMakeRange(1, 67) duration:5 repeatCount:100];
    
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



