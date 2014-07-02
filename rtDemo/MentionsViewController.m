//
//  MantionsViewController.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/29/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "MentionsViewController.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetTableViewCell.h"
#import "ProfileViewController.h"

@interface MentionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TwitterClient *client;
@property (strong, nonatomic) NSMutableArray *tweets;
@end

@implementation MentionsViewController{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.client = [TwitterClient instance];
    
    UINib *cellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetTableViewCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
}
- (void)loadMentionsTimeLine{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
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
