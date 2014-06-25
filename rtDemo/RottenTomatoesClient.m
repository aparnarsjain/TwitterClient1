//
//  RottenTomatoesClient.m
//  rtDemo
//
//  Created by Aparna Jain on 5/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "RottenTomatoesClient.h"
//#import "Movie.h"

@implementation RottenTomatoesClient

//shared instance for the rotten tomatoes client
+ (RottenTomatoesClient *)instance {
    static RottenTomatoesClient *instance = nil;
    
// not thread safe, so use the dispatch_once recipe
//    if(instance == nil) {
//        instance = [[RottenTomatoesClient alloc] init];
//    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
       instance = [[RottenTomatoesClient alloc] init];
    });
    
    return instance;
}

- (AFHTTPRequestOperation *)boxOfficeWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *movies))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"box_office" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *moviesJsonArray = responseObject[@"movies"];
//        NSArray *movies = [Movie moviesWithJsonArray: moviesJsonArray];
//        success(operation, movies);
    } failure:failure];
}
@end
