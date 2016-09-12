//
//  Animation.h
//  FicaFrio
//
//  Created by Victor Leal Porto de Almeida Arruda on 08/09/16.
//  Copyright © 2016 PokeGroup. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) rotation:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithZoomInAnimation:(float)secs option:(UIViewAnimationOptions)option delay:(float)delay nextImege:(UIImageView*)image;


@end
