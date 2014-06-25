//
//  TweetDetailViewController.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/22/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;

//extern NSString *const ReplyToTweetClicked;
//extern NSString *const FavoriteClicked;
//extern NSString *const RetweetClicked;
@end
