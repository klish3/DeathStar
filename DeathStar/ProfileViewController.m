//
//  ProfileViewController.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 03/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//



#import "ProfileViewController.h"
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
#import "InstagramDetailViewController.h"
#import "PresentInstagramDetailTransition.h"
#import "DismissIntagramDetailTransition.h"

typedef NS_ENUM(NSUInteger, UYLTwitterSearchState)
{
    UYLTwitterSearchStateLoading,
    UYLTwitterSearchStateNotFound,
    UYLTwitterSearchStateRefused,
    UYLTwitterSearchStateFailed
};


@interface ProfileViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UILabel *restName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *twitterDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *membershipStatus;


@property (strong, nonatomic) NSArray *array;

@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *instaPhotos;
@property (nonatomic) NSString *instaSearchText;

//TwitterSearch
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *buffer;
@property (nonatomic,strong) NSMutableArray *results;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,assign) UYLTwitterSearchState searchState;


@property (nonatomic) NSString *twitterSearchText;

@end

@implementation ProfileViewController{
    NSArray *_array; // Can't auto-synthesize. We override the only accessor.
}

- (NSArray *)array {
    if (! _array) {
        _array = [NSArray new];
    }
    return _array;
}

@synthesize instaPhotos, currentViewController, placeholderView, twitterSearch, instaSearch, twitterSearchtableView, twwitterFeedTableView;

#pragma mark ---
#pragma mark viewDidAppear
#pragma mark ---

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Profile Awake");
    CoreDataStack *coreDataStack = [[CoreDataStack alloc] init];
     //////
    NSFetchRequest *fetchUser = [NSFetchRequest fetchRequestWithEntityName:@"ProfileEdit"];
     NSFetchRequest *fetchRest = [NSFetchRequest fetchRequestWithEntityName:@"ProfileEdit"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProfileEdit" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    fetchUser.resultType = NSDictionaryResultType;
    fetchUser.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"userName"]];
    fetchUser.returnsDistinctResults = YES;
    
    fetchRest.resultType = NSDictionaryResultType;
    fetchRest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"resturauntName"]];
    fetchRest.returnsDistinctResults = YES;
    
    // Now it should yield an NSArray of distinct values in dictionaries.
    NSArray *dictionariesUser = [coreDataStack.managedObjectContext executeFetchRequest:fetchUser error:nil];
    NSArray *dictionariesRest = [coreDataStack.managedObjectContext executeFetchRequest:fetchRest error:nil];
   
    if (dictionariesRest.count != 0 && dictionariesUser != 0) {
       
   
    
        NSString * user = [[dictionariesUser valueForKey:@"userName"] objectAtIndex:dictionariesRest.count-1];
        NSString * restuarnat = [[dictionariesRest valueForKey:@"resturauntName"] objectAtIndex:dictionariesUser.count-1];
       
        self.userName.text = restuarnat;
        self.restName.text = user;
    }else {
        
        self.userName.text = @"Tawi";
        self.restName.text = @"Tawi";
        
    }
    //FROM FABRIC Login in Intergration
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
          //   NSLog(@"signed in as %@", [session userName]);
             //   NSLog(@"signed in as %@", [session authToken]);
             //   NSLog(@"signed in as %@", [session authTokenSecret]);
             self.twitterDisplayName.text = [session userName];
             
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
    
    /*TWitter Access View Custom Client == Sort out
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[TwitterClient sharedInstance] fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"tgldeathstardemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request Token %@,", requestToken);
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
       [[UIApplication sharedApplication] openURL:authURL];

    } failure:^(NSError *error) {
        NSLog(@"Failed to get request Token");
        NSLog(@"%@",error);
    }];
     */
   
}
#pragma mark ---
#pragma mark ViewDidLoad
#pragma mark ---
- (void)viewDidLoad {
    [super viewDidLoad];
    [self twitterTimeTable];
    //Clean out FB/Twt login process, still messy
  //  FBLoginView *loginView = [[FBLoginView alloc] init];
  //  loginView.center = self.view.center;
  //  [self.view addSubview:loginView];
    
    TWTRLogInButton* logInButton =  [TWTRLogInButton
                                     buttonWithLogInCompletion:
                                     ^(TWTRSession* session, NSError* error) {
                                         if (session) {
                                             NSLog(@"Twitter signed in as %@", [session userName]);
                                             logInButton.center = self.twwitterFeedTableView.center;
                                             [self.view addSubview:logInButton];
                                         } else {
                                             NSLog(@"error: %@", [error localizedDescription]);
                                             
                                         }
    }];
    
    //Collection View Layout
    double instaBoxSize = 110.0;
    
    self.instaFlow.itemSize = CGSizeMake(instaBoxSize, instaBoxSize);
    self.instaFlow.minimumInteritemSpacing = 1.0;

    [self.instagramCollectionView registerClass:[InstagramCollectionViewCell class] forCellWithReuseIdentifier:@"InstaPhoto"];
     self.instagramCollectionView.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:43/255.0f alpha:1.0f];
   
    
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefualts objectForKey:@"accessToken"];

    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            //NSLog(@"response: %@",responseObject);
            self.accessToken = responseObject[@"credentials"][@"token"];
            [userDefualts setObject:self.accessToken forKey:@"accessToken"];
            [userDefualts synchronize];
            [self refreshInsta];
            
        }];
    } else {
        [self refreshInsta];
     }
    //UIRefresh Controll
   
    [self socialPullRefresh];
    
    if (self.query.length ==0 ) {
        self.query = @"food";
    }
    
    self.title = self.query;
   // NSLog(@"ViewDidLoad query: %@",self.query);
    [self loadQuery];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor greenColor]];
    
}

#pragma mark ---
#pragma mark Social Pull Refresh
#pragma mark ---

- (void)socialPullRefresh {
    UIRefreshControl *refreshControlTwitter = [[UIRefreshControl alloc] init];
    UIRefreshControl *refreshControlTwitterSearch = [[UIRefreshControl alloc] init];
    UIRefreshControl *refreshControlInstagram = [[UIRefreshControl alloc] init];
    [refreshControlTwitter addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [refreshControlTwitterSearch addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [refreshControlInstagram addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    
    [refreshControlInstagram beginRefreshing];
    
    
    [self.twitterSearchtableView addSubview:refreshControlTwitterSearch];
    [self.twwitterFeedTableView addSubview:refreshControlTwitter];
    [self.instagramCollectionView addSubview:refreshControlInstagram];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];

}

#pragma mark Display Tweet Fabric API
- (void)sampleTwiiterFabric {
    
    
    [[[Twitter sharedInstance] APIClient] loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
        
        
        if (tweet) {
            TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
            tweetView.center = self.twwitterFeedTableView.center;
            [self.view addSubview:tweetView];
        } else {
            NSLog(@"Error loading Tweet: %@", [error localizedDescription]);
        }
        
    }];
    
    
    [TWTRTweetView appearance].primaryTextColor = [UIColor greenColor];
    [TWTRTweetView appearance].backgroundColor = [UIColor blackColor];
    
    
    
}

-(void) refreshInsta {
    
    if (self.instaSearchText == NULL) {
        self.instaSearchText = @"Food";
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", self.instaSearchText, self.accessToken];
   
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
       // NSLog(@"%@",responseDictionary);
       // self.instaPhotos = [responseDictionary valueForKeyPath:@"data.images.standard_resolution.url"];
        self.instaPhotos = [responseDictionary valueForKeyPath:@"data"];
        
        //NSLog(@"%lu",(unsigned long)self.instaPhotos.count);
        
       dispatch_async(dispatch_get_main_queue(), ^{
          
           [self.instagramCollectionView reloadData];
           
       });
    }];
    
    [task resume];
    
   // NSLog(@"Signed In With %@", self.accessToken);
    self.instaSearchText = @"";
}

#pragma mark ---
#pragma mark Instagram Collection View
#pragma mark ---

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.instaPhotos.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   InstagramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstaPhoto" forIndexPath:indexPath];
    cell.backgroundColor  = [UIColor lightGrayColor];
    cell.instaPhotoImage = self.instaPhotos[indexPath.row];
    
   // NSLog(@"%@",indexPath);
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDictionary *photo = self.instaPhotos[indexPath.row];
    InstagramDetailViewController *viewController = [[InstagramDetailViewController alloc]init];
    
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate =self;
    
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
    //NSLog(@"didSelectItemAtIndexPath");
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    return [[PresentInstagramDetailTransition alloc] init];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [[DismissIntagramDetailTransition alloc] init];
}

#pragma mark ---
#pragma mark ComposeTweet
#pragma mark ---
- (IBAction)ComposeTweet:(UIButton *)sender {
    
        
    TWTRComposer *composer = [[TWTRComposer alloc] init];
     [composer setText: @"TWeet here,......"];
    [composer setImage:[UIImage imageNamed:@"fabric"]];
    
    [composer showWithCompletion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
    
}

-(void)dismissSelf{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---
#pragma mark TableView Data Source
#pragma mark ---


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    if (tableView == self.twwitterFeedTableView) {
        return [_array count];
    } else {
        
        NSUInteger count = [self.results count];
        
        return count > 0 ? count : 1;
        
    }
    
  }

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.twwitterFeedTableView) {
        static NSString *cellID =  @"CELLID" ;
        UITableViewCell *cell = [self.twwitterFeedTableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        // Creates an NSDictionary that holds the user's posts and then loads the data into each cell of the table view.
        NSDictionary *tweetFeed = _array[indexPath.row];
        cell.textLabel.text = tweetFeed[@"text"];
        return cell;
        
    } else {
        
        static NSString *ResultCellIdentifier = @"ResultCell";
        static NSString *LoadCellIdentifier = @"LoadingCell";
        
        NSUInteger count = [self.results count];
        // NSLog(@"Count: %lu",(unsigned long)count);
        if ((count == 0) && (indexPath.row == 0))
        {
            
            UITableViewCell *cellSearch = [self.twitterSearchtableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
            cellSearch.textLabel.text = [self searchMessageForState:self.searchState];
            return cellSearch;
        }
        
        UITableViewCell *cellSearch = [self.twitterSearchtableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
        NSDictionary *tweetSearch = (self.results)[indexPath.row];
        cellSearch.textLabel.text = tweetSearch[@"text"];
        
        return cellSearch;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.twwitterFeedTableView) {
    
        NSLog(@"Search Row Tapped");
    }else {
        
        NSLog(@"Feed Row Tapped");
    }
}

#pragma mark ---
#pragma mark TableView TwitterSearch
#pragma mark ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.twitterSearchtableView) {
    
                if (indexPath.row & 1)
                {
                    
                    cell.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
                }
                else
                {
                    cell.textColor = [UIColor whiteColor];
                    cell.backgroundColor = [UIColor colorWithRed:57.0/255.0f green:57.0/255.0f blue:57.0/255.0f alpha:1.0f];
                }
    }
}


#pragma mark ---
#pragma mark TWitterTimeline AcAccount
#pragma mark ---
//Twitter Timeline Using AcAccount (The account linked to the device
-(void)twitterTimeTable {
    
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            NSLog(@"Granted Twitter Feed");
            
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            if([arrayOfAccounts count] > 0){
                
                ACAccount *TwitterAccount = [arrayOfAccounts lastObject];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
                [paramaters setObject:@"100" forKey:@"count"];
                [paramaters setObject:@"1" forKey:@"include_entities"];
                
                SLRequest *post = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:paramaters];
                post.account = TwitterAccount;
                [post performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    self.array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] ;
                    
                    if (self.array.count != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                            [self.twwitterFeedTableView reloadData];
                            
                        });
                    }
                }];
            }
        } else
            NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark ---
#pragma mark Twitter Search
#pragma mark ---
//Twitter Search
- (NSString *)searchMessageForState:(UYLTwitterSearchState)state
{
    switch (state)
    {
        case UYLTwitterSearchStateLoading:
            return @"Loading...";
            break;
        case UYLTwitterSearchStateNotFound:
            return @"No results found";
            break;
        case UYLTwitterSearchStateRefused:
            return @"Twitter Access Refused";
            break;
        default:
            return @"Not Available";
            break;
    }
}
////
- (void)loadQuery
{
    if (self.query == 0) {
        NSString *tempQuery = @"Food";
        self.query = tempQuery;
    } else {
        self.query = self.query;
    }
    
    self.searchState = UYLTwitterSearchStateLoading;
    NSString *encodedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
          if (granted == YES)
         {
             NSLog(@"Granted Twitter Search");
             NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
            // NSDictionary *parameters = @{@"count" : RESULTS_PERPAGE, @"q" : encodedQuery};
             NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
             
             [paramaters setObject:@"100" forKey:@"count"];
             
             [paramaters setObject:encodedQuery forKey:@"q"];
             
             
             SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:paramaters];
             
             NSArray *accounts = [account accountsWithAccountType:accountType];
             
             
             slRequest.account = [accounts lastObject];
             
             NSURLRequest *request = [slRequest preparedURLRequest];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 
             });
           
             
         }
         else
         {
             
             self.searchState = UYLTwitterSearchStateRefused;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.twitterSearchtableView reloadData];
             });
             
              NSLog(@"NOt Granted: %@", [error localizedDescription]);
             
             
         }
     }];
   self.query = @"";
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.buffer = [NSMutableData data];
  //  NSLog(@"connection didReceiveResponse: %@", self.buffer);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.buffer appendData:data];
   // NSLog(@"connection didReceiveData: %@", self.buffer);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:self.buffer options:0 error:&jsonParsingError];
    
    //NSLog(@"JSOn Results: %@", jsonResults);
    
    self.results = jsonResults[@"statuses"];
    if ([self.results count] == 0)
    {
        NSArray *errors = jsonResults[@"errors"];
        if ([errors count])
        {
            self.searchState = UYLTwitterSearchStateFailed;
                //NSLog(@"UYLTwitterSearchStateFailed");
        }
        else
        {
            self.searchState = UYLTwitterSearchStateNotFound;
          //  NSLog(@"UYLTwitterSearchStateNotFound");
        }
    }
    
    self.buffer = nil;
   [[UIRefreshControl alloc] endRefreshing];
    [self.twitterSearchtableView reloadData];
    [self.twitterSearchtableView flashScrollIndicators];
     NSLog(@"connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    self.buffer = nil;
    [[UIRefreshControl alloc] endRefreshing];
    self.searchState = UYLTwitterSearchStateFailed;
    
    [self handleError:error];
    [self.twitterSearchtableView reloadData];
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)cancelConnection
{
    if (self.connection != nil)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.connection cancel];
        self.connection = nil;
        self.buffer = nil;
    }
}


- (IBAction)reloadTweetSearch:(id)sender {
    [self loadQuery];
}
#pragma mark ---
#pragma mark UISearchBars
#pragma mark ---
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 
    if (searchBar == self.instaSearch) {
        
        self.instaSearchText = searchText;
   
    } else if (searchBar == self.twitterSearch) {
        
        self.twitterSearchText = searchText;
    } else {
        NSLog(@"Unable to set Search Text");
        
    }
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar == self.instaSearch) {
        
        [self refreshInsta];
        
    } else if (searchBar == self.twitterSearch) {
        
        self.query = self.twitterSearchText;
        NSLog(@"Twitter Search Query Button Clicked: %@",self.query);
        [self loadQuery];
        
        [self.twitterSearchtableView reloadData];
    } else {
        NSLog(@"Unable to perfom Search");
        
    }
    
}





@end
