//
//  TwitterClient.h
//  rtDemo
//
//  Created by Aparna Jain on 5/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;
- (void) login;
- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (BOOL)openURL:(NSURL *)url;
@property (nonatomic, strong) NSMutableArray *tweets;

- (AFHTTPRequestOperation *)tweetWithParams:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)userWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)setFavoriteWithParams:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)reTweetWithParams:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
