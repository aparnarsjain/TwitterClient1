//
//  MantionsViewController.h
//  TwitterOAuth
//
//  Created by Aparna Jain on 6/29/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tweet;

@interface MentionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) Tweet *tweet;
@end
