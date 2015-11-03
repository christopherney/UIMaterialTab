//
//  ViewController.m
//  Example
//
//  Created by Christopher Ney on 03/11/2015.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.homeViewController == nil) {
        
        self.delegate = self;
        
        self.colorBackgroundPager = [UIColor whiteColor];
        self.colorBackgroundStatusBar = [UIColor redColor];
        self.colorBackgroundTabBar = [UIColor lightGrayColor];
        self.colorBackgroundTabBarItem = [UIColor lightGrayColor];
        self.colorBackgroundTabBarItemSelected = [UIColor lightGrayColor];
        self.colorTabBarIndicator = [UIColor redColor];
        
        self.viewController1 = [[UIViewController alloc] init];
        self.viewController2 = [[UIViewController alloc] init];
        self.viewController3 = [[UIViewController alloc] init];
        self.viewController4 = [[UIViewController alloc] init];
        self.viewController5 = [[UIViewController alloc] init];
        
        NSArray *vcs = @[
                         self.viewController1,
                         self.viewController2,
                         self.viewController3,
                         self.viewController4,
                         self.viewController5
                         ];
        
        [self setViewControllers:vcs];
    }
}

- (void)materialTab:(UIMaterialTab *)materialTab didSelectTabIndex:(NSInteger)tabIndex {
    
    NSLog(@"Tab selected %ld", tabIndex);
}

@end
