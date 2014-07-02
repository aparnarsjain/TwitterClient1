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
#import "ProfileViewController.h"
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
    NSLog(@"MEntions %hhd", self.mentions);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    UINib *cellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetTableViewCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(onComposeButtonClick:)];
    [composeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = composeButton;
    self.client = [TwitterClient instance];

    if(self.mentions){
        [self loadMentionsData];
    }else {
        if([self.client.tweets count] == 0){
            [self loadData:nil];
        }else {
            self.tweets = self.client.tweets;
        }
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
    [center addObserverForName:RetweetClicked object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self onRetweetButtonClick:notification.userInfo];
     }];
    
    [center addObserverForName:TweetCreatedNotification object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self addNewTweet:notification.userInfo];
     }];


    [self pullToRefreshSetUp];
}
- (void) addNewTweet: (NSDictionary *)userInfo {
    Tweet *currTweet = userInfo[@"tweet"];
    [self.tweets insertObject:currTweet atIndex:0];
    [self.tableView reloadData];
}
- (void) onRetweetButtonClick:(NSDictionary *)userInfo {
    Tweet *currTweet = userInfo[@"tweet"];

    [self.client reTweetWithParams:@{@"id": currTweet.id} andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"retweet done!, %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error retweeting!, %@", error);
    }];
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
- (void)loadMentionsData {
    [self.client mentionsTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [responseObject count]; i++) {
            [self.tweets addObject:[MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject[i] error:nil]];
        }
        [self.tableView reloadData];
        
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
    
    tweetCell.imgUser.userInteractionEnabled = YES;
    tweetCell.imgUser.tag = indexPath.row;

    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile:)];
    tapped.numberOfTapsRequired = 1;
    [tweetCell.imgUser addGestureRecognizer:tapped];

    return tweetCell;
}
- (void)showProfile: (UITapGestureRecognizer *)sender
{
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    Tweet *currTweet = self.tweets[sender.view.tag];
    vc.screenName = currTweet.screenName;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
