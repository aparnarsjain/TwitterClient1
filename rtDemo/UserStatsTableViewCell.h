//
//  UserStatsTableViewCell.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/29/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserStatsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfTweets;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfFollowers;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfFollowing;
@property (strong, nonatomic) NSDictionary *userStats;

@end
