//
//  EndViewController.m
//  FicaFrio
//
//  Created by Bárbara Souza on 25/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "EndViewController.h"

@interface EndViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *tagText;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *step1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *step2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *step3;

@end

@implementation EndViewController

- (void)awakeWithContext:(NSArray<NSNumber*>*)context {
    [super awakeWithContext:context];
    _tagText.text = [[NSNumber numberWithInt: context.count] stringValue];
    [_step1 setWidth:30];
    [_step1 setHeight:30];
    [_step3 setHeight:50];
    [_step3 setWidth: 50];
    
    
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



