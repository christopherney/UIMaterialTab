//
//  IMaterialTab.m
//  iMaterialTabs
//
//  Created by Christopher Ney on 08/09/2015.
//  Copyright (c) 2015 Christopher Ney. All rights reserved.
//

#import "UIMaterialTab.h"

#define kMaterialTabStatusBarHeight 20.0
#define kMaterialTabBarHeight 49.0
#define kMaterialTabBarIndicatorHeight 4.0

@interface UIMaterialTab ()
- (void)initialize;
- (void)buildTabs;
- (void)tabDidTouchUpInside:(id)sender;
- (void)setTabBarIndicatorPosition;
- (UIViewController<UIMaterialTabViewControllerDelegate>*)getViewControllerAtIndex:(NSInteger)index;
@end

@implementation UIMaterialTab

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self initialize];
}

- (void)initialize {
    
    if (_tabBar == nil) {
        
        CGFloat statusBarOffset = 0.0;
        
        if ([UIApplication sharedApplication].statusBarHidden == NO)
            statusBarOffset = kMaterialTabStatusBarHeight;
    
        _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, kMaterialTabBarHeight + statusBarOffset)];
        _tabBar.backgroundColor = self.colorBackgroundStatusBar;
        [self.view addSubview:_tabBar];
 
        
        _scrollViewTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, statusBarOffset, _tabBar.bounds.size.width, kMaterialTabBarHeight)];
        _scrollViewTabBar.backgroundColor = self.colorBackgroundTabBar;
        [_scrollViewTabBar setPagingEnabled:YES];
        [_scrollViewTabBar setShowsHorizontalScrollIndicator:NO];
        [_tabBar addSubview:_scrollViewTabBar];
        
        
        _scrollViewPager = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, _tabBar.bounds.size.height, _tabBar.bounds.size.width, self.view.bounds.size.height - _tabBar.bounds.size.height)];
        _scrollViewPager.backgroundColor = self.colorBackgroundPager;
        _scrollViewPager.delegate = self;
        [_scrollViewPager setPagingEnabled:YES];
        [_scrollViewPager setShowsHorizontalScrollIndicator:NO];
        [self.view addSubview:_scrollViewPager];
        
        
        _tabIndicator = [[UIView alloc] initWithFrame:CGRectMake(0.0,  _tabBar.bounds.size.height - kMaterialTabBarIndicatorHeight, _tabBar.bounds.size.width, kMaterialTabBarIndicatorHeight)];
        _tabIndicator.backgroundColor = self.colorTabBarIndicator;
        [_tabBar addSubview:_tabIndicator];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    [self initialize];
    
    for (UIView *viewTab in [_scrollViewTabBar subviews]) {
        [viewTab removeFromSuperview];
    }
    
    for (UIView *viewPage in [_scrollViewPager subviews]) {
        [viewPage removeFromSuperview];
    }
    
    _viewControllers = nil;
    _viewControllers = viewControllers;
    
    [self buildTabs];
}

- (UIViewController<UIMaterialTabViewControllerDelegate>*)getViewControllerAtIndex:(NSInteger)index {
    
    if (_viewControllers != nil && [_viewControllers count] > index) {
        
        UIViewController<UIMaterialTabViewControllerDelegate> *viewController = (UIViewController<UIMaterialTabViewControllerDelegate>*)[_viewControllers objectAtIndex:index];
        
        return viewController;
        
    } else {
        return nil;
    }
}

- (void)buildTabs {
    
    _tabWidth = _tabBar.bounds.size.width / [_viewControllers count];
    
    _tabIndicator.frame = CGRectMake(0.0,  _tabBar.bounds.size.height - kMaterialTabBarIndicatorHeight, _tabWidth, kMaterialTabBarIndicatorHeight);
    
    if (_tabButtons != nil) {
        [_tabButtons removeAllObjects];
    } else {
        _tabButtons = [[NSMutableArray alloc] init];
    }
 
    for (int i = 0; i < _viewControllers.count; i++) {
        
        UIViewController<UIMaterialTabViewControllerDelegate> *viewController = [self getViewControllerAtIndex:i];
        
        UIButton *buttonTab = [[UIButton alloc] initWithFrame:CGRectMake(i * _tabWidth, 0.0, _tabWidth, kMaterialTabBarHeight)];
        buttonTab.tag = i;
        [buttonTab addTarget:self action:@selector(tabDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([viewController respondsToSelector:@selector(materialTabBarTitle)] && [viewController materialTabBarTitle] != nil) {
            
            NSString *title = [viewController materialTabBarTitle];
            
            [buttonTab setTitle:title forState:UIControlStateNormal];
            
        } else {
            
            UIImage *iconSelected = [viewController materialTabBarIconSelected];
            UIImage *iconUnselected = [viewController materialTabBarIconUnselected];
            
            [buttonTab setTitle:nil forState:UIControlStateNormal];
            [buttonTab setImage:iconSelected forState:UIControlStateHighlighted];
            [buttonTab setImage:iconSelected forState:UIControlStateSelected];
            [buttonTab setImage:iconUnselected forState:UIControlStateDisabled];
            [buttonTab setImage:iconUnselected forState:UIControlStateNormal];
        }
 
        [_scrollViewTabBar addSubview:buttonTab];
        [_tabButtons addObject:buttonTab];
        
        if (i == 0) {
            buttonTab.selected = YES;
        }
        
        [viewController.view setFrame:CGRectMake(i * _scrollViewPager.bounds.size.width, 0.0, _scrollViewPager.bounds.size.width, _scrollViewPager.bounds.size.height)];
        [_scrollViewPager addSubview:viewController.view];
    }
    
    
    [_scrollViewTabBar setContentSize:CGSizeMake([_viewControllers count] * _tabWidth, kMaterialTabBarHeight)];
    [_scrollViewPager setContentSize:CGSizeMake([_viewControllers count] * _scrollViewPager.bounds.size.width, _scrollViewPager.bounds.size.height)];
}

- (void)tabDidTouchUpInside:(id)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *tabButton  = (UIButton*)sender;
        
        NSInteger selectedIndex = tabButton.tag;
        
        [self selectTabIndex:selectedIndex];
    }
}

- (void)selectTabIndex:(NSInteger)selectedIndex {
    
    BOOL animated = NO;
    
    if (labs(_indexSelected - selectedIndex) <= 1) animated = YES;
    
    _indexSelected = selectedIndex;
    
    [_scrollViewPager scrollRectToVisible:CGRectMake(
                                                     (_indexSelected * _scrollViewPager.bounds.size.width),
                                                     0.0,
                                                     _scrollViewPager.bounds.size.width,
                                                     _scrollViewPager.bounds.size.height)
                                 animated:animated];
    
    [self setTabBarIndicatorPosition];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _indexSelected = _scrollViewPager.contentOffset.x / _scrollViewPager.bounds.size.width;
    
    [self setTabBarIndicatorPosition];
}

- (void)setTabBarIndicatorPosition {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _tabIndicator.frame = CGRectMake(
                                         _tabWidth * _indexSelected,
                                         _tabBar.bounds.size.height - kMaterialTabBarIndicatorHeight,
                                         _tabWidth,
                                         kMaterialTabBarIndicatorHeight
                                         );
        
    } completion:^(BOOL finished) {
        
    }];
    
    for (int index = 0; index < _tabButtons.count; index++) {
        
        UIButton *tabBarButton = (UIButton*)[_tabButtons objectAtIndex:index];
        
        UIViewController<UIMaterialTabViewControllerDelegate> *viewController = [self getViewControllerAtIndex:index];
        
        if (index == _indexSelected) {
            
            tabBarButton.selected = YES;
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(materialTab:didSelectTabIndex:)]) {
                [self.delegate materialTab:self didSelectTabIndex:_indexSelected];
            }
       
            if (viewController != nil && [viewController respondsToSelector:@selector(materialTab:didSelectTabIndex:)]) {
                [viewController materialTab:self didSelectTabIndex:_indexSelected];
            }
 
        } else {
            
            tabBarButton.selected = NO;
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(materialTab:didUnSelectTabIndex:)]) {
                [self.delegate materialTab:self didUnSelectTabIndex:_indexSelected];
            }
            
            if (viewController != nil && [viewController respondsToSelector:@selector(materialTab:didUnSelectTabIndex:)]) {
                [viewController materialTab:self didUnSelectTabIndex:_indexSelected];
            }
        }
    }
    
}

@end
