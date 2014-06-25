//
//  TweetTableViewCell.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/20/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UIButton *btnReplyTweet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRetweet;
@property (weak, nonatomic) IBOutlet UIView *viewRetweet;
@property (weak, nonatomic) IBOutlet UILabel *lblSomeoneRetweeted;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) Tweet *tweet;

extern NSString *const ReplyToTweetClicked;
extern NSString *const FavoriteClicked;
extern NSString *const RetweetClicked;

@end
