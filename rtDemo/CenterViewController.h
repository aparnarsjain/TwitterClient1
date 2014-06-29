//
//  CenterViewController.h
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/11/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void) movePanelRight;


@required
- (void) movePanelToOriginalPosition;

@end

@interface CenterViewController : UIViewController

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@end
