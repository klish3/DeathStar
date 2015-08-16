//
//  CustomSegue.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 13/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "CustomSegue.h"
#import "ViewController.h"


@implementation CustomSegue

-(void) perform  {
    
    ViewController *src = (ViewController *)[self sourceViewController];
    UIViewController *dst = (UIViewController *) self.destinationViewController;
       
    for (UIView *view in src.placeholderView.subviews ) {
        [view removeFromSuperview];
    }
    
   
    src.currentViewController = dst;
    [src.placeholderView addSubview:dst.view];
}


@end
