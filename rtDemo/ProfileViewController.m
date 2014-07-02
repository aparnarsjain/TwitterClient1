//
//  FirstViewController.m
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"
#import "TweetDetailViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UserStatsTableViewCell.h"
#import "ProfileHeaderView.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TwitterClient *client;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (assign, nonatomic) CGRect cachedImageViewSize;
@property (strong, nonatomic) UserStatsTableViewCell *statsCell;
@property (strong, nonatomic) ProfileHeaderView *headerView;
@property (assign, nonatomic) BOOL isUserLoggedIn;
@end

@implementation ProfileViewController{
    TweetTableViewCell *_stubCell;
    UserStatsTableViewCell *_statsStubCell;
}

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    self.headerView = [[ProfileHeaderView alloc] init];
//    self.headerView.clipsToBounds = YES;
//    self.tableView.tableHeaderView = self.headerView;
    
    self.headerView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.headerView.clipsToBounds = NO;
    self.tableView.tableHeaderView = self.headerView;

    UINib *cellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetTableViewCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    UINib *stubCellNib = [UINib nibWithNibName:@"UserStatsTableViewCell" bundle:nil];
    [self.tableView registerNib:stubCellNib forCellReuseIdentifier:@"UserStatsTableViewCell"];
    _statsStubCell = [stubCellNib instantiateWithOwner:nil options:nil][0];
    self.statsCell = [[UserStatsTableViewCell alloc] init];
    
    self.client = [TwitterClient instance];
    [self loadUser];
    self.cachedImageViewSize = self.headerView.imgBanner.frame;
}

- (void) loadUser {
    NSString *loggedInUserScreenName = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"logged_in_user_screen_name"]];
    
    self.isUserLoggedIn = [self.screenName isEqualToString:loggedInUserScreenName] ? YES : NO;
    
    if (self.screenName == nil) {
        self.screenName = loggedInUserScreenName;
    }
    if(self.isUserLoggedIn){
        if(self.client.user == nil){
            [self fetchLoggedInUserAndLoadProfile];
        } else {
            [self fetchProfileData:self.client.user.screenName];
        }
    }else {
        [self fetchProfileData:self.screenName];
    }
}
- (void)fetchLoggedInUserAndLoadProfile{
    [self.client userWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user =  [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        
        [self fetchProfileData:self.user.screenName];
        self.headerView.user = self.user;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"No user %@", error);
    }];
}
- (void) setUpHeaderView {
//    self.headerView = [[ProfileHeaderView alloc] init];
//    self.tableView.tableHeaderView = self.headerView;
}
- (void)fetchRequestedUserAndLoadProfile{
    
}
- (void) fetchProfileData: (NSString *)screenName {
    //get timeline
    [self.client userTimeline:@{@"screen_name": screenName} andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [responseObject count]; i++) {
            [self.tweets addObject:[MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject[i] error:nil]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading user timeline %@", error);
    }];
    
    //get user stats
    [self.client userLookup:@{@"screen_name": screenName} andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.statsCell.userStats = @{@"tweets": responseObject[0][@"statuses_count"],
                                     @"followers": responseObject[0][@"followers_count"],
                                     @"following": responseObject[0][@"friends_count"]};
        if(!self.isUserLoggedIn){
            self.user =  [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject[0] error:nil];
            self.headerView.user = self.user;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error getting user lookup%@", error);
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = -scrollView.contentOffset.y;
    if (y > 0) {
        self.headerView.imgBanner.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y);
        self.headerView.imgBanner.center = CGPointMake(self.view.center.x, self.headerView.imgBanner.center.y);
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >0 ) {
        CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }else {
        return 50;
    }
//    CGSize size = [_statsStubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height+1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 0){
            return 130.f;
    }else {
            return 1.1f;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        self.statsCell = [tableView dequeueReusableCellWithIdentifier:@"UserStatsTableViewCell" forIndexPath:indexPath];
        return self.statsCell;
        
    } else {
        TweetTableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];
        tweetCell.tweet = self.tweets[indexPath.row -1];
        tweetCell.btnReplyTweet.tag = indexPath.row -1;
        return tweetCell;

    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
////
//    return self.headerView;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return self.headerView.frame.size.height;
//}

@end
