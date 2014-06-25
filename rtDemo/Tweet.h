//
//  Tweet.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/20/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface Tweet : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy, readonly) NSString *userImageUrl;
@property (nonatomic, copy, readonly) NSNumber *retweets;
@property (nonatomic, copy, readonly) NSNumber *favorites;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *screenName;
@property (nonatomic, copy, readonly) NSString *retweetedByName;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSString *createdAt;
@property (nonatomic, copy, readonly) NSNumber *id;
@end
