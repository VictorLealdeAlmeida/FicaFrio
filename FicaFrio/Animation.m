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
                         self.transform = CGAffineTransformRotate(self.transform, M_PI*2/3);
                     }
                     completion:nil];
}

@end