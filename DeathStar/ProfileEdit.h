//
//  ProfileEdit.h
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 23/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface ProfileEdit : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * resturauntName;
@property (nonatomic, retain) NSData * userImage;
@property (nonatomic, retain) NSString * location;

@end
