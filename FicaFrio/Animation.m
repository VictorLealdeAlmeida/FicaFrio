//
//  Animation.m
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 08/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//

#import "Animation.h"

@implementation UIView (Animation)

- (void) rotation:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, -M_PI*2/3);
                     }
                     completion:nil];
}

- (void) rotationOpposite:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI*2/3);
                     }
                     completion:nil];
}

- (void) addSubviewWithZoomInAnimation:(float)secs option:(UIViewAnimationOptions)option delay:(float)delay nextImege:(UIImageView*)image
{
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay: delay options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:secs delay:0.0 options:option
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 0.83, 0.83);
                                          }
                                          completion:^(BOOL finished){
                                              image.hidden = NO;
                                          }];
                     }];
}

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

@end