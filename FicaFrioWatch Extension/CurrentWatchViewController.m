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
    if (!flag){
        //Por aq vai passar o valor pra ligar o stop no ios
        NSString *startStop = [NSString stringWithFormat:@"%d", 1];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToIphone"]];
        
        [[WCSession defaultSession] sendMessage:applicationData
                                   replyHandler:^(NSDictionary *reply) {
                                       //handle reply from iPhone app here
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       NSLog(@"Deu erro");
                                   }
         ];
    }else{
        //Por aq vai passar o valor pra ligar o start no ios
        NSString *startStop = [NSString stringWithFormat:@"%d", 0];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[startStop] forKeys:@[@"startStopToIphone"]];
        
        [[WCSession defaultSession] sendMessage:applicationData
                                   replyHandler:^(NSDictionary *reply) {
                                       //handle reply from iPhone app here
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       NSLog(@"Deu erro");
                                   }
         ];
    }
    
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

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    
    NSString *counterValue = [message objectForKey:@"startStopToWatch"];
    
    NSLog(@"%@",counterValue);
    if ([counterValue integerValue] == 0){
        statusButton = true;
    }else{
        statusButton = false;
    }
    
    [self changeStartButton];

    
}


@end
