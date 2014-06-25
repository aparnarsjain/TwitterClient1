//
//  ComposeViewController.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/21/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Tweet.h"

NSString * const TweetCreatedNotification = @"TweetCreatedNotification";

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet UITextField *composeTextField;
@property (nonatomic, strong) TwitterClient *client;
@property (nonatomic, strong) User *user;
@property (strong,nonatomic)UILabel *countLabel;

@end
NSInteger const MAX_TWEET_COUNT = 140;

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.client tweetWithParams:@{@"status": self.composeTextField.text} andSuccess:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Tweeted %@", response);
        self.tweetCreated = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:response error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TweetCreatedNotification object:self userInfo:@{@"tweet": self.tweetCreated}];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet failed %@", error);
    }];
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.client = [TwitterClient instance];
    [self.client userWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user =  [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        [self fillUIElementsWithData];
        NSLog(@"user object, %@", responseObject);
        [self loadViewWithUserInformation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"No user %@", error);
    }];
    [self.composeTextField becomeFirstResponder];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButtonClick)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    if(self.replyTo){
        self.composeTextField.text = [NSString stringWithFormat:@"@%@ ",self.replyTo];
    }
    [self setUpSubViews];

    self.composeTextField.delegate = self;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)MAX_TWEET_COUNT-self.composeTextField.text.length];

}
- (void) setUpSubViews {
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 12, 40, 20)];
    self.countLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.countLabel];
}
- (void) fillUIElementsWithData {
    self.lblScreenName.text = self.user.screenName;
    self.imgUserProfile.layer.cornerRadius = 5;
    self.imgUserProfile.clipsToBounds=YES;
    [self.imgUserProfile setImageWithURL:[NSURL URLWithString:self.user.userImageUrl]];
}
- (void)onCancelButtonClick {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void) loadViewWithUserInformation {
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)MAX_TWEET_COUNT-textField.text.length];
    
}
@end
