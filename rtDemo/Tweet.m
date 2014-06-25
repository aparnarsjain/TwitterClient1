//
//  Tweet.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/20/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userImageUrl": @"user.profile_image_url",
             @"retweets": @"retweet_count",
             @"favorites": @"favorite_count",
             @"name": @"user.name",
             @"screenName": @"user.screen_name",
             @"text": @"text",
             @"createdAt": @"created_at",
             @"id": @"id",
             @"retweetedByName": @"retweeted_status.user.screen_name",
            };
    
//    return @{
//             @"userImageUrl": @"http://pbs.twimg.com/profile_background_images/446411201413541888/uY6CCUHT.png",
//             @"retweets": @"227",
//             @"favorites": @"819",
//             @"name": @"Ellen DeGeneres",
//             @"screenName": @"TheEllenShow",
//             @"text": @"I met Sirdeaner Walker on my show. She founded a wonderful anti-bullying foundation. Find out more about it, here. http://t.co/OkFUPWY1Zu",
//             @"createdAt": @"Thu Aug 14 03:50:42 +0000 2008"
//             };
}

//+ (NSValueTransformer *)createdAtJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
//        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
//    } reverseBlock:^(NSDate *date) {
//        return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
//    }];
//}
@end
