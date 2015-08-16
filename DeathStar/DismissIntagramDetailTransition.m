//
//  DismissIntagramDetailTransition.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 27/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "DismissIntagramDetailTransition.h"

@implementation DismissIntagramDetailTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


@end
