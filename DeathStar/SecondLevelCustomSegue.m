//
//  SecondLevelCustomSegue.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 04/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "SecondLevelCustomSegue.h"
#import "ProfileViewController.h"
#import "ViewController.h"

@implementation SecondLevelCustomSegue

-(void) perform  {
    
    ViewController *secondSrc = (ViewController *)[self sourceViewController];
    ProfileViewController *secondDst = (ProfileViewController *) self.destinationViewController;
    
    for (UIView *view in secondSrc.placeholderView.subviews ) {
        [view removeFromSuperview];
    }
    
    
    secondSrc.currentViewController = secondDst;
    [secondSrc.placeholderView addSubview:secondDst.view];
}


@end
