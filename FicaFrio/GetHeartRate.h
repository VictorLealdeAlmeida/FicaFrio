//
//  GetHeartRate.h
//  FicaFrio
//
//  Created by Diana Monteiro on 15/09/16.
//  Copyright © 2016 CMG Research Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GetHeartRate : NSObject

@property (nonatomic, weak) UIImageView *heartBeating;

-(void) pause;
-(void) resume;
-(void) startCameraCapture;
-(void) stopCameraCapture;

@end
