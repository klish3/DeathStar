//
//  ProfileViewController.h
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 03/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileEdit.h"
#import "ProfileEditViewController.h"
#import "CoreDataStack.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <TwitterKit/TwitterKit.h>
#import "TwitterClient.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "InstagramCollectionViewCell.h"
#import <SimpleAuth/SimpleAuth.h>

@class ProfileEdit;

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *twwitterFeedTableView;
@property (weak, nonatomic) IBOutlet UITableView *twitterSearchtableView;

@property (weak, nonatomic) UICollectionViewController *collection;
@property (weak, nonatomic) IBOutlet UICollectionView *instagramCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *instaFlow;


@property (nonatomic, weak) IBOutlet UIView *placeholderView;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic,strong) ProfileEdit *edit;

- (IBAction)ComposeTweet:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *twitterSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *instaSearch;

@property (nonatomic, copy) NSString *query;
@property (weak, nonatomic) IBOutlet UIView *ReloadTwiitersearch;

@end
