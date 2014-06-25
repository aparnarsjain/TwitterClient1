//
//  RottenTomatoesClient.h
//  rtDemo
//
//  Created by Aparna Jain on 5/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface RottenTomatoesClient : AFHTTPRequestOperationManager

+ (RottenTomatoesClient *)instance;

- (AFHTTPRequestOperation *)boxOfficeWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *movies))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
