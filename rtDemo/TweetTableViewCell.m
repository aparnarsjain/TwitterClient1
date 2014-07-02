//
//  TweetTableViewCell.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/20/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"
#import <QuartzCore/QuartzCore.h>
#import "ComposeViewController.h"
#import "ProfileViewController.h"

NSString * const ReplyToTweetClicked = @"ReplyToTweetClicked";
NSString * const FavoriteClicked = @"FavoriteClicked";
NSString * const RetweetClicked = @"RetweetClicked";

@implementation TweetTableViewCell

static NSDateFormatter *formatter = nil;

- (IBAction)onImageClick:(id)sender {
//    ProfileViewController *vc = [[ProfileViewController alloc] init];
//    vc.screenName = self.tweets[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onReplyClick:(id)sender {
    //open the compose view controller with the handle inserted
    [[NSNotificationCenter defaultCenter] postNotificationName:ReplyToTweetClicked object:self userInfo: @{@"sender": sender, @"tweet": self.tweet}];
}
- (IBAction)onFavoriteClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:FavoriteClicked object:self userInfo: @{@"sender": sender, @"tweet": _tweet}];
}
- (IBAction)onRetweetClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:RetweetClicked object:self userInfo: @{@"sender": sender, @"tweet": _tweet}];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.lblName.text = tweet.name;
    self.lblScreenName.text = [NSString stringWithFormat:@"%@%@", @"@", tweet.screenName];
    self.lblText.text = tweet.text;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    if (tweet.retweetedByName) {
        self.lblSomeoneRetweeted.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetedByName];
    }else {
        self.viewRetweet.hidden = YES;
        self.constraintRetweet.constant -= 30;
    }
    self.lblTime.text = [MHPrettyDate prettyDateFromDate:[formatter dateFromString:tweet.createdAt] withFormat:MHPrettyDateShortRelativeTime];
    self.imgUser.layer.cornerRadius = 5;
    self.imgUser.clipsToBounds=YES;
    [self.imgUser setImageWithURL:[NSURL URLWithString:tweet.userImageUrl]];
}

@end
