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
#import "FirstViewController.h"
#import "HamburgerMenuTableViewCell.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 120
#define FRACTION_TO_COMPLETE 2

@interface MainViewController () <CenterViewControllerDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, LeftPanelViewControllerDelegate>
@property (nonatomic, strong) CenterViewController *centerViewController;
@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, strong) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblView;
@property (strong, nonatomic) UIBarButtonItem *leftPanelButton;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) UIViewController *previousViewController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewControllers = @[[[FirstViewController alloc] init],
                                 [[SecondViewController alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
}

- (void)setUpView {
    self.leftPanelButton = [[UIBarButtonItem alloc] initWithTitle:@"LeftPanel" style:UIBarButtonItemStyleDone target:self action:@selector(btnMovePanelRight:)];
    self.leftPanelButton.tag = 1;

    self.navigationItem.leftBarButtonItem = self.leftPanelButton;
    self.currentViewController = self.viewControllers[0];
    self.previousViewController = self.currentViewController;
    self.currentViewController.view.tag = CENTER_TAG;

    [self.view addSubview:self.currentViewController.view];
    [self addChildViewController:_currentViewController];
    [self setupGestures];
    
}
- (void)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
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
        [_currentViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_currentViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_currentViewController.view.layer setShadowOpacity:0.8];
        [_currentViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }else {
        [_currentViewController.view.layer setCornerRadius:0.0f];
        [_currentViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}
- (UIView *)getLeftView
{
    if (_leftPanelViewController == nil){
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.delegate = self;

        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
       
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        [self.view addSubview:self.leftPanelViewController.view];//view controller containment
        
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
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _currentViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
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
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         NSLog(@"current view controller %@", _currentViewController);
                         

                         _currentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
    
    [_currentViewController.view addGestureRecognizer:panRecognizer];
    
}

-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer *)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan){
        UIView *childView = nil;
        
        if(velocity.x > 0){
            childView = [self getLeftView];
        }
        
        [self.view sendSubviewToBack:childView];
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
        _showPanel = abs([sender view].center.x - _currentViewController.view.frame.size.width/2) > _currentViewController.view.frame.size.width/FRACTION_TO_COMPLETE;
        NSLog(@"velocity %f", velocity.x);
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0){
//            NSLog(@"same direction");
        }else{
//            NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
}
#pragma mark Table View Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//	return [self.menuItems count];
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    	return [self.viewControllers count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    MenuItem *item = self.menuItems[section];
//	return item.title;
    return @"Title";
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HamburgerMenuTableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"HamburgerMenuTableViewCell" forIndexPath:indexPath];
//    MenuItem *item = self.menuItems[indexPath.section];
    menuCell.lblCellText.text = @"dynamic text";
    
    return menuCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIView *currView = ((UIViewController *)self.viewControllers[indexPath.row]).view;
    UIView *currView = ((UIViewController *)self.viewControllers[indexPath.row]).view;
    currView.frame = self.view.frame;
    [self.view addSubview:currView];
    [self.view bringSubviewToFront:currView];

}

#pragma LeftPanel Delegate
- (void) rowClicked:(NSInteger)row {
    self.previousViewController = self.currentViewController;
    self.currentViewController = self.viewControllers[row];
    if (self.previousViewController != self.currentViewController) {
        UIView *currView = self.currentViewController.view;
        currView.frame = self.view.frame;
        [self.previousViewController.view removeFromSuperview];
        [self.view addSubview:currView];
    }
    [self movePanelToOriginalPosition];

}
@end
