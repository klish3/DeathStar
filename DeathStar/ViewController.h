//
//  ViewController.h
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 07/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,weak) IBOutlet UIView *tabsView;

@property (nonatomic, weak) IBOutlet UIView *placeholderView;

@property (nonatomic, strong) UIViewController *currentViewController;



@end

