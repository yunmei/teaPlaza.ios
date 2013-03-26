//
//  IndexViewController.h
//  teaPlaza
//
//  Created by bevin chen on 13-3-23.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *adScrollView;
@property (strong, nonatomic) UIPageControl *adPageControl;
@property (strong, nonatomic) NSMutableArray *adArray;
@property (strong, nonatomic) NSMutableArray *appArray;
@property (nonatomic) BOOL IS_iPhone5;
@property (strong, nonatomic) UIView *appView;

@end
