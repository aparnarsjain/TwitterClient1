//
//  LeftPanelViewController.m
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/11/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "ProfileHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
AppDelegate *appDelegate;

@interface LeftPanelViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (strong, nonatomic)NSArray *menutItems;
@end

@implementation LeftPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.headerView = [[UIView alloc] init];
        UINib *nib = [UINib nibWithNibName:@"DrawerHeaderView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        UIView *subView = objects[0];
        self.headerView.frame = CGRectMake(10, 510, subView.frame.size.width, subView.frame.size.height);

        self.headerView = subView;
        self.menutItems = @[@"Timeline", @"Profile", @"Mentions", @"Sign Out"];
//        [self.headerView addSubview:subView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//    self.headerView.clipsToBounds = YES;

    self.lblScreenName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"logged_in_user_screen_name"];
    self.lblName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"logged_in_user"];
    [self.imgUserProfile setImageWithURL:[[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"logged_in_user_profile_image"]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSignOutButtonClick {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"signed_in"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"signed in in tweets view controller %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"signed_in"]);
    appDelegate =[[UIApplication sharedApplication] delegate];
    [appDelegate loadAppropriateViewController];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.delegate numberOfRowsInSection];
    return [self.menutItems count];

//    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.menutItems[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3){ //sign out
        [self onSignOutButtonClick];
    }else {
        [self.delegate rowClicked:indexPath.row];
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 100)];
//    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
//    label.text = [NSString stringWithFormat:@"Section %i", section];
//    
//    [headerView addSubview:label];
//    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120.0f;
}

@end
