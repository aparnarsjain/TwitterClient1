//
//  TweetsViewController.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 5/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetTableViewCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "TweetDetailViewController.h"

AppDelegate *appDelegate;

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TwitterClient *client;

@end

@implementation TweetsViewController{
    TweetTableViewCell *_stubCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    UINib *cellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetTableViewCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(onSignOutButtonClick)];
    [signOutButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = signOutButton;

    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(onComposeButtonClick:)];
    [composeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = composeButton;
    self.client = [TwitterClient instance];
    if([self.client.tweets count] == 0){
        [self loadData:nil];
    }else {
        self.tweets = self.client.tweets;
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:ReplyToTweetClicked object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self onComposeButtonClick:notification.userInfo[@"tweet"]];
     }];
    [center addObserverForName:FavoriteClicked object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self setFavorite:notification.userInfo];
     }];
    [center addObserverForName:ReplyToTweetClicked object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self onComposeButtonClick:notification.userInfo[@"tweet"]];
     }];


    [self pullToRefreshSetUp];
}
- (void)styleButton:(UIButton *)button forState:(BOOL)state{
    if (state) {
        button.tintColor = [UIColor greenColor];
    }
    else{
        button.tintColor = [UIColor darkGrayColor];
    }
}
- (void) setFavorite:(NSDictionary *)userInfo {
    Tweet *currTweet = userInfo[@"tweet"];
    __weak TweetsViewController *weakSelf = self;
    [self.client setFavoriteWithParams:@{@"id": currTweet.id} andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"favorite added %@", responseObject);
        [weakSelf styleButton:userInfo[@"sender"] forState:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"favorite error %@", error);
    }];
}
- (void)pullToRefreshSetUp {
    //alloc a table view controller and then point it to this view controller's tableview
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self.tableView;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    tvc.refreshControl = refresh;
}
- (void)loadData: (id)sender{
   [self.client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       self.tweets = [[NSMutableArray alloc] init];
       for (NSInteger i = 0; i < [responseObject count]; i++) {
           [self.tweets addObject:[MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject[i] error:nil]];
       }
       [self.tableView reloadData];
       if(sender){
           [(UIRefreshControl *)sender endRefreshing];
       }

   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"error loading timeline %@", error);
   }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onComposeButtonClick:(id)tweet {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    if([tweet isKindOfClass:[Tweet class]]){
        Tweet *currtweet = tweet;
        cvc.replyTo = currtweet.screenName;
    }
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:cvc];
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)onSignOutButtonClick {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"signed_in"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"signed in in tweets view controller %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"signed_in"]);    
    appDelegate =[[UIApplication sharedApplication] delegate];
    [appDelegate loadAppropriateViewController];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 TweetTableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];
    tweetCell.tweet = self.tweets[indexPath.row];
    tweetCell.btnReplyTweet.tag = indexPath.row;
    return tweetCell;
}
@end
