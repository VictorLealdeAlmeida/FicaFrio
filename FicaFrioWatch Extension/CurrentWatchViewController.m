//
//  CurrentWatchViewController.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 20/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "CurrentWatchViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface CurrentWatchViewController() <WCSessionDelegate>{
    BOOL flag;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageSet;
//@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *startStop;
- (IBAction)startStopButton;

@end


@implementation CurrentWatchViewController

bool statusButton = false;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    flag = NO;
    [_imageSet setImageNamed:@"relogio"];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)startStopButton {
    NSString *startStop = [NSString stringWithFormat:@"%d", 23];
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStop"]];
    
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                                   NSLog(@"Deu erro");
                               }
     ];
    
    [self changeStartButton];
    
}

- (void)changeStartButton {
    if (flag){
        [_imageSet stopAnimating];
        [_imageSet setImageNamed:@"relogio"];
        flag = NO;
    }else{
        [_imageSet setImageNamed:@"relogio"];
        [_imageSet startAnimating];
        flag = YES;
    }
}


@end
