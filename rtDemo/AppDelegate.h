//
//  AppDelegate.h
//  rtDemo
//
//  Created by Aparna Jain on 5/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const ReplyToTweetClicked;
extern NSString *const FavoriteClicked;
extern NSString *const RetweetClicked;
extern NSString *const TweetCreatedNotification;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)loadAppropriateViewController;

@end
