//
//  AccountsViewController.m
//  twitterAccountSwitchAnimationDemo
//
//  Created by Aparna Jain on 7/1/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "AccountsViewController.h"
#import "MainViewController.h"

@interface AccountsViewController ()
@property  (strong, nonatomic) NSArray *subViews;
@property (nonatomic, strong) MainViewController *mainPanelViewController;

@end

@implementation AccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.mainPanelViewController.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"Views" bundle:nil];
    self.subViews = [nib instantiateWithOwner:nil options:nil];
    
    UIView *tealView = self.subViews[0];
    [self.view addSubview:tealView];
    
    UIView *orangeView = self.subViews[1];
    orangeView.frame = CGRectMake(0, 200, orangeView.frame.size.width, orangeView.frame.size.height);
    [self.view addSubview:orangeView];
    self.view.clipsToBounds = YES;
//    [self setUpGestures];

}
//-(void) setUpGestures {
//    UILongPressGestureRecognizer *holdRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(animateViews:)];
//    [holdRecognizer setMinimumPressDuration:1];
//    [self.btnAccounts addGestureRecognizer:holdRecognizer];
//
//
//}
-(void) animateViews {
    UIView *orangeView = self.subViews[1];
    orangeView.frame = CGRectMake(0, 200, orangeView.frame.size.width, orangeView.frame.size.height);
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         orangeView.frame = CGRectMake(0, 100, orangeView.frame.size.width, orangeView.frame.size.height);

                     }
                     completion:^(BOOL finished) {
                         if (finished) {

                         }
                         
                     }
     ];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAccountsClick:(id)sender {
}

- (IBAction)onHomeClick:(id)sender {
}
@end
