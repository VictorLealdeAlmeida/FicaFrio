//
//  InfoStepInterfaceController.m
//  FicaFrio
//
//  Created by Bárbara Souza on 24/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "InfoStepInterfaceController.h"

@interface InfoStepInterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *textStep;

@end

@implementation InfoStepInterfaceController

- (void)awakeWithContext:(NSString*)context {
    [super awakeWithContext:context];
    _textStep.text = context;
    
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



