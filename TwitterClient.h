//
//  TwitterClient.h
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 11/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+(TwitterClient *)sharedInstance;

@end
