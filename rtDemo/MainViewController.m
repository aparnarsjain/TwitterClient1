//
//  MainViewController.m
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/11/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "MainViewController.h"
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import "SecondViewController.h"
#import "ProfileViewController.h"
#import "HamburgerMenuTableViewCell.h"
#import "TweetsViewController.h"
#import "AppDelegate.h"
#import "MentionsViewController.h"
#import "AccountsViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 120
#define FRACTION_TO_COMPLETE 2

AppDelegate *appDelegate;

@interface MainViewController () <CenterViewControllerDelegate, UIGestureRecognizerDelegate, LeftPanelViewControllerDelegate>
@property (nonatomic, strong) CenterViewController *centerViewController;
@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, strong) NSArray *viewControllers;
@property (strong, nonatomic) UIBarButtonItem *leftPanelButton;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) UIViewController *previousViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnAccounts;
- (IBAction)onAccountsClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
- (IBAction)onHomeButtonClick:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewControllers = @[[[TweetsViewController alloc] init],
                                 [[ProfileViewController alloc] init],
                                 [[TweetsViewController alloc] init]
                                 ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
    
    //TODO: put this in the left menu
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(onSignOutButtonClick)];
    [signOutButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = signOutButton;

}
- (void)onSignOutButtonClick {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"signed_in"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"signed in in tweets view controller %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"signed_in"]);
    appDelegate =[[UIApplication sharedApplication] delegate];
    [appDelegate loadAppropriateViewController];
}
- (void)setUpView {
    self.leftPanelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnMovePanelRight:)];

    self.currentViewController = self.viewControllers[0];
    self.previousViewController = self.currentViewController;
    self.currentViewController.view.tag = CENTER_TAG;
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:self.currentViewController];
    [_navigationController willMoveToParentViewController:self];
    self.leftPanelButton.tag = 1;

    self.currentViewController.navigationItem.leftBarButtonItem = self.leftPanelButton;

    self.navigationController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.navigationController.view];
    [self setupGestures];
    
}
- (void)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
    NSLog(@"button tag %d", button.tag);
    switch (button.tag){
        case 0: {
            [self movePanelToOriginalPosition];
            break;
        }
        case 1: {
            [self movePanelRight];
            break;
        }
        default:
            break;
    }
    
}
- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if(value){
        [_navigationController.view.layer setCornerRadius:CORNER_RADIUS];
        [_navigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_navigationController.view.layer setShadowOpacity:0.8];
        [_navigationController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }else {
        [_navigationController.view.layer setCornerRadius:0.0f];
        [_navigationController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}
- (UIView *)getLeftView
{
    if (_leftPanelViewController == nil){
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.delegate = self;

        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
       
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.contentView.frame.size.height);

        [self.contentView addSubview:self.leftPanelViewController.view];//view controller containment
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
    }
    
    self.showingLeftPanel = YES;
    
    //set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getLeftView];
    [self.contentView sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navigationController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.contentView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.leftPanelButton.tag = 0;
                         }
                         
                     }
     ];
}
- (void)resetMainView
{
    if (_leftPanelViewController != nil) {
//        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        
        self.leftPanelButton.tag = 1;
        self.showingLeftPanel = NO;
    }
      // remove view shadows
//    [self showCenterViewWithShadow:NO withOffset:0];
}

- (void) movePanelToOriginalPosition {
    self.navigationController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.contentView.frame.size.height);

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         NSLog(@"current view controller %@", _currentViewController);
//                         self.navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         self.navigationController.view.frame = self.contentView.frame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                            [self resetMainView];
                         }
                         
                     }
     ];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_navigationController.view addGestureRecognizer:panRecognizer];
    
}

-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer *)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.contentView];
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan){
        UIView *childView = nil;
        
        if(velocity.x > 0){
            childView = [self getLeftView];
        }
        
        [self.contentView sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer *)sender view]];
        
    }
    if([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded){
        if(!_showPanel){
            [self movePanelToOriginalPosition];
        }else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            }
        }
    }
    if([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateChanged){
        _showPanel = abs([sender view].center.x - _navigationController.view.frame.size.width/2) > _navigationController.view.frame.size.width/FRACTION_TO_COMPLETE;
        NSLog(@"velocity %f", velocity.x);
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0) inView:self.contentView];
        
        _preVelocity = velocity;
    }
}

#pragma LeftPanel Delegate
- (void) rowClicked:(NSInteger)row {
    self.previousViewController = self.navigationController;
    
    self.currentViewController = self.viewControllers[row];
    [self.navigationController setViewControllers:@[self.currentViewController]];

    self.currentViewController.navigationItem.leftBarButtonItem = self.leftPanelButton;
    if (row == 2) { //mentions row, load normal timeline
        TweetsViewController *currController = [[TweetsViewController alloc] init];
        currController.mentions = YES;
        [self.navigationController setViewControllers:@[currController]];
        currController.navigationItem.leftBarButtonItem = self.leftPanelButton;
        
    }
    if (self.previousViewController != self.currentViewController) {
        UIView *currView = self.navigationController.view;
        currView.frame = self.contentView.frame;
        [self.previousViewController.view removeFromSuperview];
        self.previousViewController = nil;
        [self.contentView addSubview:currView];
    }

    [self movePanelToOriginalPosition];
    [self setupGestures];


}
- (NSInteger)numberOfRowsInSection {
    return [self.viewControllers count];
}
- (IBAction)onAccountsClick:(id)sender {
    self.previousViewController = self.navigationController;
    AccountsViewController *currController = [[AccountsViewController alloc] init];
    [self.navigationController setViewControllers:@[currController]];
    currController.navigationItem.leftBarButtonItem = self.leftPanelButton;
    UIView *currView = self.navigationController.view;
    currView.frame = self.contentView.frame;
    [self.previousViewController.view removeFromSuperview];
    self.previousViewController = nil;
    [self.contentView addSubview:currView];
}
- (IBAction)onHomeButtonClick:(id)sender {
}
-(void) setUpGestures {
    UILongPressGestureRecognizer *holdRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(animateViews:)];
    [holdRecognizer setMinimumPressDuration:1];
    [self.btnAccounts addGestureRecognizer:holdRecognizer];
    
}
-(void) animateViews: (UILongPressGestureRecognizer *)gestureRecognizer{
    [self.delegate animateViews];
}
@end
