//
//  TwitterClient.m
//  rtDemo
//
//  Created by Aparna Jain on 5/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetsViewController.h"
#import "AppDelegate.h"
#import "User.h"

AppDelegate *appDelegate;


@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end


@implementation TwitterClient


+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    //this is not packageable
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"kDPd944K0642a6XxVeYUHmNPv" consumerSecret:@"20j7v1rGqOsW5q4MErc8fV24cTPyZChwjNlgH5WZPviwIDIWKn"];
    });
    
    return instance;
}

- (void) login {
    [self.requestSerializer removeAccessToken];

    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token!");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", [error description]);
    }];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)userWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}
- (AFHTTPRequestOperation *)tweetWithParams:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    return [self POST:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)setFavoriteWithParams:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
        return [self POST:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
    
}
- (AFHTTPRequestOperation *)reTweetWithParams:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *postString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", params[@"id"]];
    return [self POST:postString parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)profileBanner:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/users/profile_banner.json" parameters:params success:success failure:failure];
    
}
- (AFHTTPRequestOperation *)userTimeline:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:success failure:failure];
    
}
- (AFHTTPRequestOperation *)userLookup:(NSDictionary *)params andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/users/lookup.json" parameters:params success:success failure:failure];
}
- (AFHTTPRequestOperation *)mentionsTimeLineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:success failure:failure];
}

- (BOOL)openURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"cptwitter"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]){
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"Access token!");
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        self.tweets = [[NSMutableArray alloc] init];
                        for (NSInteger i = 0; i < [responseObject count]; i++) {
                            [self.tweets addObject:[MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject[i] error:nil]];
                        }
                        NSLog(@"formatted dictionaries- %@", self.tweets);
                        
                        //get the logged in user
                        [client userWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                            self.user =  [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
                            NSLog(@"user object, %@", responseObject);
                            [[NSUserDefaults standardUserDefaults] setObject:self.user.screenName forKey:@"logged_in_user_screen_name"];
                            [[NSUserDefaults standardUserDefaults] setObject:self.user.name forKey:@"logged_in_user"];
                            [[NSUserDefaults standardUserDefaults] setObject:self.user.userImageUrl forKey:@"logged_in_user_profile_image"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"No user %@", error);
                        }];

                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"signed_in"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        NSLog(@"signed in- in twitter client? %hhd", [[NSUserDefaults standardUserDefaults] boolForKey:@"signed_in"] );
                        
                        [appDelegate loadAppropriateViewController];
                        
                    
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"response error");
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"error");
                }];
            }
        }
        return YES;
    }
    return NO;
}

@end
