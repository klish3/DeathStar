//
//  InstagramDetailViewController.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 26/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "InstagramDetailViewController.h"
#import "InstagramPhotoController.h"
#import "ProfileViewController.h"
#import "InstagramMetaData.h"

@interface InstagramDetailViewController ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL *ifLikedDetail;
@property (nonatomic) NSDictionary *instaPhotoImage;
@property (nonatomic) InstagramMetaData *metaData;
@end


@implementation InstagramDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.9];
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    
    self.metaData = [[InstagramMetaData alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 550.0f, 650.0f)];
    self.metaData.alpha = 0.0f;
    self.metaData.photo = self.photo;
    [self.view addSubview:self.metaData];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -320.0, 640.0f, 640.0f)];
    self.imageView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:0.4f];
    [self.view addSubview:self.imageView];
    
    [self ifLiked];
    
    
    [InstagramPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image){
        
        self.imageView.image = image;
    }];
    ///////------ NEEDS WORK -------///////
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
    likeTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:likeTap];
   
    UILongPressGestureRecognizer *holdToUnlike = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(unLike)];
    holdToUnlike.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:holdToUnlike];
    
    UISwipeGestureRecognizer *swipeClose = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    swipeClose.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeClose];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGPoint point = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    self.metaData.center = point;
    [UIView animateWithDuration:0.5 delay:0.7 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:kNilOptions animations:^{
        self.metaData.alpha = 1.0f;
    } completion:nil];
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGSize imageSize = CGSizeMake(550.0, 550.0);

   // CGSize imageSize = CGSizeMake(550.0, 550.0);
   // CGSize imageSize = CGSizeMake(size.width, size.width);
    
    self.imageView.frame = CGRectMake((size.width - imageSize.width)/2.0, (size.height - imageSize.height)/2.0, imageSize.width, imageSize.height);
    
}

-(void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --
#pragma mark LIKED, UNLIKED, IF LIKED
#pragma mark -- Fix -----
#pragma mark --
-(void)like {
    // NSLog(@"Link: %@",self.instaPhotoImage[@"link"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    

    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         NSLog(@"response liked: %@",response);
       
      //  NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
        
    }];
    [task resume];
    
}

-(void)unLike {
    // NSLog(@"Link: %@",self.instaPhotoImage[@"link"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    
  
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"DEL";

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response unlike: %@",response);
        
        //  NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showUnlikedCompletion];
        });
        
    }];
    [task resume];
    
}



//Check and Fix
-(void)ifLiked {
    // NSLog(@"Link: %@",self.instaPhotoImage[@"link"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    
    NSLog(@"accessToken: %@", accessToken);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      NSLog(@"response ifLiked: %@",response);
        
        
    }];
    [task resume];
    
    
    return;
}

-(void)showLikeCompletion {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    
    
    
}
-(void)showUnlikedCompletion {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unliked" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    
    
    
}
@end
