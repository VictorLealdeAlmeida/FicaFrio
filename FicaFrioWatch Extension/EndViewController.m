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
    CGFloat valorMedio = 40, valorMaior = 50, valorMenor = 30;
    [super awakeWithContext:context];
    //_tagText.text = [[NSNumber numberWithInt: context.count] stringValue];
    if(([context[0] doubleValue] == [context[1] doubleValue]) && ([context[0] doubleValue] == [context[2] doubleValue])){
        [_step1 setHeight:valorMedio];
        [_step1 setWidth:valorMedio];
        [_step2 setWidth:valorMedio];
        [_step2 setHeight:valorMedio];
        [_step3 setWidth:valorMedio];
        [_step3 setHeight:valorMedio];
        
    }else if (([context[0] doubleValue] != [context[1] doubleValue]) && ([context[0] doubleValue] != [context[2] doubleValue]) && ([context[1] doubleValue] != [context[2] doubleValue])){
        // All values are different
        if(([context[0] doubleValue] > [context[1] doubleValue]) && ([context[0] doubleValue] > [context[2] doubleValue])){
            [_step1 setHeight: valorMaior];
            [_step1 setHeight:valorMaior];
            if(([context[1] doubleValue] > [context[2] doubleValue])){
                [_step2 setWidth:valorMedio];
                [_step2 setHeight:valorMedio];
                [_step3 setWidth:valorMenor];
                [_step3 setHeight:valorMenor];
            }else{
                [_step2 setWidth:valorMenor];
                [_step2 setHeight:valorMenor];
                [_step3 setWidth:valorMedio];
                [_step3 setHeight:valorMedio];
            }
        }else if (([context[1] doubleValue] > [context[0] doubleValue]) && ([context[1] doubleValue] > [context[2] doubleValue])){
            [_step2 setHeight: valorMaior];
            [_step2 setHeight:valorMaior];
            if(([context[0] doubleValue] > [context[2] doubleValue])){
                [_step1 setWidth:valorMedio];
                [_step1 setHeight:valorMedio];
                [_step3 setWidth:valorMenor];
                [_step3 setHeight:valorMenor];
            }else{
                [_step1 setWidth:valorMenor];
                [_step1 setHeight:valorMenor];
                [_step3 setWidth:valorMedio];
                [_step3 setHeight:valorMedio];
            }
        }else if (([context[2] doubleValue] > [context[0] doubleValue]) && ([context[2] doubleValue] > [context[0] doubleValue])){
            [_step3 setHeight: valorMaior];
            [_step3 setHeight:valorMaior];
            if(([context[0] doubleValue] > [context[1] doubleValue])){
                [_step1 setWidth:valorMedio];
                [_step1 setHeight:valorMedio];
                [_step2 setWidth:valorMenor];
                [_step2 setHeight:valorMenor];
            }else{
                [_step1 setWidth:valorMenor];
                [_step1 setHeight:valorMenor];
                [_step2 setWidth:valorMedio];
                [_step2 setHeight:valorMedio];
            }
            
        }

    }else{
    // Only one value is different
        if(([context[0] doubleValue] == [context[1] doubleValue])){
            if (([context[0] doubleValue] > [context[2] doubleValue])){
                [_step2 setWidth:valorMedio];
                [_step2 setHeight:valorMedio];
                [_step1 setWidth:valorMedio];
                [_step1 setHeight:valorMedio];
                [_step3 setWidth:valorMenor];
                [_step3 setHeight:valorMenor];
            }else{
                [_step2 setWidth:valorMenor];
                [_step2 setHeight:valorMenor];
                [_step1 setWidth:valorMenor];
                [_step1 setHeight:valorMenor];
                [_step3 setWidth:valorMedio];
                [_step3 setHeight:valorMedio];
            
            }
        
        }else if (([context[0] doubleValue] == [context[2] doubleValue])){
            if (([context[0] doubleValue] > [context[1] doubleValue])){
                [_step3 setWidth:valorMedio];
                [_step3 setHeight:valorMedio];
                [_step1 setWidth:valorMedio];
                [_step1 setHeight:valorMedio];
                [_step2 setWidth:valorMenor];
                [_step2 setHeight:valorMenor];
            }else{
                [_step3 setWidth:valorMenor];
                [_step3 setHeight:valorMenor];
                [_step1 setWidth:valorMenor];
                [_step1 setHeight:valorMenor];
                [_step2 setWidth:valorMedio];
                [_step2 setHeight:valorMedio];
                
            }
        
        }else if (([context[1] doubleValue] == [context[2] doubleValue])){
            if (([context[1] doubleValue] > [context[0] doubleValue])){
                [_step3 setWidth:valorMedio];
                [_step3 setHeight:valorMedio];
                [_step2 setWidth:valorMedio];
                [_step2 setHeight:valorMedio];
                [_step1 setWidth:valorMenor];
                [_step1 setHeight:valorMenor];
            }else{
                [_step3 setWidth:valorMenor];
                [_step3 setHeight:valorMenor];
                [_step2 setWidth:valorMenor];
                [_step2 setHeight:valorMenor];
                [_step1 setWidth:valorMedio];
                [_step1 setHeight:valorMedio];
                
            }
        
        }
    }
    
    
    
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



