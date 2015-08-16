//
//  InstagramCollectionViewCell.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 20/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "InstagramCollectionViewCell.h"
#import "InstagramPhotoController.h"
@implementation InstagramCollectionViewCell


-(void)setInstaPhotoImage:(NSDictionary *)instaPhotoImage {
    _instaPhotoImage = instaPhotoImage;
    
   [InstagramPhotoController imageForPhoto:_instaPhotoImage size:@"thumbnail" completion:^(UIImage *image) {
       self.instaImageView.image = image;
      // NSLog(@"image: %@",image);
   }];
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.instaImageView = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        likeTap.numberOfTapsRequired = 2;        
        [self addGestureRecognizer:likeTap];

        
        [self.contentView addSubview:self.instaImageView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.instaImageView.frame = self.contentView.bounds;
}

-(void)like {
   // NSLog(@"Link: %@",self.instaPhotoImage[@"link"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.instaPhotoImage[@"id"], accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        
       // NSLog(@"response: %@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
        
    }];
    [task resume];
    
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
@end
