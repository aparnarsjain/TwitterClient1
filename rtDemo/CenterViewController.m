//
//  CenterViewController.m
//  SlideOutNavigation
//
//  Created by Aparna Jain on 6/11/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"home";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)btnMovePanelRight:(id)sender {
//    UIButton *button = sender;
//    switch (button.tag){
//        case 0: {
//            [_delegate movePanelToOriginalPosition];
//            break;
//        }
//            
//        case 1: {
//            [_delegate movePanelRight];
//            break;
//        }
//            
//        default:
//            break;
//    }
//
//}
- (void)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
    switch (button.tag){
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
    
}

@end
