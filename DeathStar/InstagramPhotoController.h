//
//  InstagramPhotoController.h
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 27/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface InstagramPhotoController : NSObject

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
