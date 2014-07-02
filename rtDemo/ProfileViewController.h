//
//  FirstViewController.h
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/28/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *screenName;
@end
