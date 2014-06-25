//
//  ComposeViewController.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/21/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tweet;
@interface ComposeViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *replyTo;
@property (nonatomic, strong) Tweet *tweetCreated;
@end
