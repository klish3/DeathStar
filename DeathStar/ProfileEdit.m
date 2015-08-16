//
//  ProfileEdit.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 23/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "ProfileEdit.h"


@implementation ProfileEdit

@dynamic date;
@dynamic userName;
@dynamic resturauntName;
@dynamic userImage;
@dynamic location;


-(NSString *)sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
