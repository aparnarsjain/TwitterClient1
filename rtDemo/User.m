
//
//  User.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/22/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
       return @{
             @"userImageUrl": @"profile_image_url",
             @"name": @"name",
             @"screenName": @"screen_name"
            };    
}


@end
