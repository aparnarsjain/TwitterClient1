//
//  LeftPanelViewController.h
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/11/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
- (void) rowClicked:(NSInteger) row;

@end

@interface LeftPanelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate;

@end
