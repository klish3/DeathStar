//
//  ViewController.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 07/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

@synthesize currentViewController, placeholderView, tabsView;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"HomeSegue"]
       || [segue.identifier isEqualToString:@"ProfileSegue"]
       || [segue.identifier isEqualToString:@"AnalyticsSegue"]){
        
        for (int i=0; i<[self.tabsView.subviews count];i++) {
            UIButton *button = (UIButton *)[self.tabsView.subviews objectAtIndex:i];
            [button setSelected:NO];
        }
        
        UIButton *button = (UIButton *)sender;
        [button setSelected:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
