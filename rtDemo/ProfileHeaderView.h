//
//  ProfileHeaderView.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/30/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileHeaderView : UIView

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
@end
