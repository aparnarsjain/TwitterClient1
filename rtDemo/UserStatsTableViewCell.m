//
//  UserStatsTableViewCell.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/29/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "UserStatsTableViewCell.h"

@implementation UserStatsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setUserStats:(NSDictionary *)userStats {
    self.lblNoOfTweets.text = [NSString stringWithFormat:@"%@", userStats[@"tweets"]];
    self.lblNoOfFollowers.text = [NSString stringWithFormat:@"%@", userStats[@"followers"]];
    self.lblNoOfFollowing.text = [NSString stringWithFormat:@"%@", userStats[@"following"]];
}
@end
