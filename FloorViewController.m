//
//  FloorViewController.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 02/03/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "FloorViewController.h"

@interface FloorViewController ()


@property (nonatomic) NSString *numbers;

@end

@implementation FloorViewController

@synthesize label;

int Num = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button:(id)sender {
    
    Num = Num + 1;
    NSLog(@"%d",Num);
     self.label.text = [NSString stringWithFormat:@"%d", Num];
    
 
    
}



@end
