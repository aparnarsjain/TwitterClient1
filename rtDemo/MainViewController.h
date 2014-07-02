//
//  MainViewController.h
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/11/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewControllerDelegate <NSObject>

@optional
- (void) animateViews;

@end
@interface MainViewController : UIViewController
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, assign) id<MainViewControllerDelegate> delegate;

@end
