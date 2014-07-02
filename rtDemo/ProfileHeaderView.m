//
//  ProfileHeaderView.m
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/30/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderView()

//@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
//@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;

@end
@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        
        UIView *subview = objects[0];
        self.frame = subview.frame;
        [self addSubview:objects[0]];
//        self.imgProfileView.layer.cornerRadius = 5.0f;

    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    [self reloadData];
}
- (void) reloadData {
    self.lblName.text = _user.name;
    self.lblScreenName.text = [NSString stringWithFormat:@"@%@", _user.screenName];
    if(_user.profileBannerUrl){
        [self.imgBanner setImageWithURL:[[NSURL alloc] initWithString:_user.profileBannerUrl]];
    }
    [self.imgProfileView setImageWithURL:[[NSURL alloc] initWithString:_user.userImageUrl]];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
