//
//  PresentInstagramDetailTransition.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 27/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "PresentInstagramDetailTransition.h"

@implementation PresentInstagramDetailTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    detail.view.alpha = 0.0;
    
    CGRect frame = containerView.frame;
    frame.origin.y += 20.0;
    frame.size.height -= 20.0;

    detail.view.frame = frame;
    NSLog(@"Animation");
    [containerView addSubview:detail.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
