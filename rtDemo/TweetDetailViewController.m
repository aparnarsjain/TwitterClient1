//
//  TweetDetailViewController.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/22/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
- (IBAction)onFavoriteClick:(id)sender;
- (IBAction)onReplyClick:(id)sender;
- (IBAction)onRetweetClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTweetTime;
@property (nonatomic, strong) TwitterClient *client;
@property (weak, nonatomic) IBOutlet UILabel *lblCountRetweets;
@property (weak, nonatomic) IBOutlet UILabel *lblCountFavorites;
@end


@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.client = [TwitterClient instance];
    
    self.lblText.text = self.tweet.text;
    self.lblName.text = self.tweet.name;
    self.lblScreenName.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.screenName];
    self.lblTweetTime.text = self.tweet.createdAt;
    self.lblCountFavorites.text = [NSString stringWithFormat:@"%@ FAVORITES",self.tweet.favorites];
    self.lblCountRetweets.text = [NSString stringWithFormat:@"%@ RETWEETS",self.tweet.retweets];
    
    self.imgUser.layer.cornerRadius = 8.0;
    self.imgUser.clipsToBounds = YES;
    [self.imgUser setImageWithURL:[NSURL URLWithString:self.tweet.userImageUrl]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFavoriteClick:(id)sender {
    [self.client setFavoriteWithParams:@{@"id": self.tweet.id} andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"favorite added %@", responseObject);
        [sender setHighlighted:YES];
        [sender setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateHighlighted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"favorite error %@", error);
    }];
}

- (IBAction)onReplyClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ReplyToTweetClicked object:self userInfo: @{@"sender": sender, @"tweet": self.tweet}];
}

- (IBAction)onRetweetClick:(id)sender {
}
@end
