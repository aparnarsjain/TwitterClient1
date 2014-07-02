//
//  ProfileHeafderTableViewCell.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/30/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "ProfileHeaderTableViewCell.h"
#import <UIImageView+AFNetworking.h>


@interface ProfileHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;

@end
@implementation ProfileHeaderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    [self reloadData];
}
- (void) reloadData {
    
}
@end
