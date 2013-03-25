//
//  IndexViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-23.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "IndexViewController.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

@synthesize adScrollView;
@synthesize adPageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"茶广场", @"茶广场");
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_index_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_index"]];
        [self.tabBarItem setTitle:@"茶广场"];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        lable.font = [UIFont systemFontOfSize:20.0];
        lable.text = self.title;
        lable.textAlignment = UITextAlignmentCenter;
        [self.navigationItem setTitleView:lable];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Ad Scroll View
    [self.view addSubview:self.adScrollView];
    [self.view addSubview:self.adPageControl];
    
    // Testing MKNetworkKit
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"user.test" forKey:@"method"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        NSLog(@"object:%@", object);
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
}

- (void)clickBtn:(id)sender
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化操作
- (UIScrollView *)adScrollView
{
    if (adScrollView == nil) {
        adScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 135)];
        adScrollView.contentSize = CGSizeMake(320, 135);
        adScrollView.pagingEnabled = YES;
        adScrollView.scrollEnabled = YES;
        [adScrollView setShowsHorizontalScrollIndicator:NO];
        [adScrollView setBackgroundColor:[UIColor grayColor]];
        adScrollView.tag = 100;
    }
    return adScrollView;
}
- (UIPageControl *)adPageControl
{
    if (adPageControl == nil) {
        adPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(220, 105, 100, 30)];
        adPageControl.currentPage = 1;
        adPageControl.numberOfPages = 1;
    }
    return adPageControl;
}
@end
