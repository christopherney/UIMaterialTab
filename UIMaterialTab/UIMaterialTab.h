//
//  IMaterialTab.h
//  iMaterialTabs
//
//  Created by Christopher Ney on 08/09/2015.
//  Copyright (c) 2015 Christopher Ney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIMaterialTab;

@protocol UIMaterialTabViewControllerDelegate <NSObject>

@optional
- (NSString*)materialTabBarTitle;
- (UIImage*)materialTabBarIconSelected;
- (UIImage*)materialTabBarIconUnselected;
- (void)materialTab:(UIMaterialTab*)materialTab didSelectTabIndex:(NSInteger)tabIndex;
- (void)materialTab:(UIMaterialTab*)materialTab didUnSelectTabIndex:(NSInteger)tabIndex;

@end

@interface UIMaterialTab : UIViewController <UIScrollViewDelegate> {
    
    UIView *_tabIndicator;
    CGFloat _tabWidth;
    
    NSMutableArray *_tabButtons;
}

@property (nonatomic, strong, readonly) UIView *tabBar;
@property (nonatomic, strong, readonly) UIScrollView *scrollViewTabBar;
@property (nonatomic, strong, readonly) UIScrollView *scrollViewPager;

@property (nonatomic, strong, readonly) NSArray *viewControllers;

@property (nonatomic, readonly) NSInteger indexSelected;

@property (nonatomic, strong) NSObject<UIMaterialTabViewControllerDelegate> *delegate;

@property (nonatomic, strong) UIColor *colorBackgroundPager;
@property (nonatomic, strong) UIColor *colorBackgroundStatusBar;
@property (nonatomic, strong) UIColor *colorBackgroundTabBar;
@property (nonatomic, strong) UIColor *colorBackgroundTabBarItem;
@property (nonatomic, strong) UIColor *colorBackgroundTabBarItemSelected;
@property (nonatomic, strong) UIColor *colorTabBarIndicator;

- (void)setViewControllers:(NSArray *)viewControllers;

- (void)selectTabIndex:(NSInteger)selectedIndex;

@end
