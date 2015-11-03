//
//  ViewController.h
//  Example
//
//  Created by Christopher Ney on 03/11/2015.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIMaterialTab.h"

@interface TabBarViewController : UIMaterialTab <UIMaterialTabViewControllerDelegate>

@property (nonatomic, strong) UIViewController *viewController1;
@property (nonatomic, strong) UIViewController *viewController2;
@property (nonatomic, strong) UIViewController *viewController3;
@property (nonatomic, strong) UIViewController *viewController4;
@property (nonatomic, strong) UIViewController *viewController5;

@end

@end

