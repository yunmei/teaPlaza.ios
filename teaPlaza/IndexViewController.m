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
#import "ContentViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

@synthesize adScrollView;
@synthesize adPageControl;
@synthesize adArray;
@synthesize appArray;
@synthesize appView;

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
        lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lable.text = self.title;
        lable.textAlignment = UITextAlignmentCenter;
        [self.navigationItem setTitleView:lable];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add AdScrollView
    [self.view addSubview:self.adScrollView];
    [self.view addSubview:self.adPageControl];
    
    // Add Middle Label
    UILabel *middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 135, 320, 45)];
    middleLabel.backgroundColor = [UIColor clearColor];
    middleLabel.font = [UIFont systemFontOfSize:16.0];
    middleLabel.text = @"---------- 茶行业推荐应用 ----------";
    middleLabel.textAlignment = UITextAlignmentCenter;
    middleLabel.textColor = [UIColor colorWithRed:147/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [self.view addSubview:middleLabel];
    
    // Add AppView
    [self.view addSubview:self.appView];
    //[self showAppList];
    
    // 开始网络请求 adArray
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"app.getAdList" forKey:@"method"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
            self.adArray = [object objectForKey:@"result"];
            [self showAdList];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
    // appArray
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    params = [NSMutableDictionary dictionaryWithObject:@"app.getAppList" forKey:@"method"];
    if (self.IS_iPhone5) {
        [params setObject:@"12" forKey:@"num"];
    } else {
        [params setObject:@"8" forKey:@"num"];
    }
    op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
            self.appArray = [object objectForKey:@"result"];
            [self showAppList];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
    
}

- (void)adClickAction:(id)sender
{
    UIButton *btn = sender;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    ContentViewController *contentViewController = [[ContentViewController alloc]init];
    contentViewController.appId = [NSString stringWithFormat:@"%d",btn.tag];
    [self.navigationController pushViewController:contentViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.adPageControl = nil;
    self.adScrollView = nil;
    self.adArray = nil;
    self.appArray = nil;
    self.appView = nil;
}

- (void)showAdList
{
    int countAdList = [self.adArray count];
    int i = 0;
    if (countAdList > 0) {
        for(UIView* subView in [self.adScrollView subviews])
        {
            [subView removeFromSuperview];
        }
        self.adScrollView.contentSize = CGSizeMake(countAdList * 320, 135);
        for (NSMutableDictionary *o in self.adArray) {
            UIButton *adImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(320 * i, 0, 320, 135)];
            [adImageBtn setTag:[[o objectForKey:@"id"] intValue]];
            [adImageBtn addTarget:self action:@selector(adClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [YMGlobal loadImage:[o objectForKey:@"image"] andButton:adImageBtn andControlState:UIControlStateNormal];
            [self.adScrollView addSubview:adImageBtn];
            i++;
        }
        self.adPageControl.numberOfPages = countAdList;
    }
}

- (void)showAppList
{
    int countAppList = [self.appArray count];
    int showNum = self.IS_iPhone5 ? 12 : 8;
    for(UIView* subView in [self.appView subviews])
    {
        [subView removeFromSuperview];
    }
    for (int i=0; i<showNum; i++) {
        float x = 76 * (i%4) + 15;
        float y = (int)(i/4) * 88;
        UIButton *iconImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 61, 61)];
        UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(x-6, y+61, 75, 16)];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.font = [UIFont systemFontOfSize:12.0];
        iconLabel.backgroundColor = [UIColor clearColor];
        iconLabel.text = @"开发中";
        if (i < countAppList) {
            NSMutableDictionary *o = [self.appArray objectAtIndex:i];
            [iconImageBtn setTag:[[o objectForKey:@"id"] intValue]];
            [iconImageBtn addTarget:self action:@selector(adClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [YMGlobal loadImage:[o objectForKey:@"icon"] andButton:iconImageBtn andControlState:UIControlStateNormal];
            iconLabel.text = [o objectForKey:@"name"];
        } else {
            [iconImageBtn setBackgroundImage:[UIImage imageNamed:@"app"] forState:UIControlStateNormal];
            iconLabel.textColor = [UIColor grayColor];
        }
        [self.appView addSubview:iconImageBtn];
        [self.appView addSubview:iconLabel];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        int offset = (int)scrollView.contentOffset.x;
        int page = (int)(offset/320);
        if (offset%320 > 160) {
            page = page+1;
        }
        [self.adPageControl setCurrentPage:page];
    }
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
        adScrollView.delegate = self;
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
- (NSMutableArray *)adArray
{
    if (adArray == nil) {
        adArray = [[NSMutableArray alloc]init];
    }
    return adArray;
}
- (NSMutableArray *)appArray
{
    if (appArray == nil) {
        appArray = [[NSMutableArray alloc]init];
    }
    return appArray;
}
- (BOOL) IS_iPhone5
{
    _IS_iPhone5 = NO;
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        _IS_iPhone5 = YES;
    }
    return _IS_iPhone5;
}
- (UIView *)appView
{
    if (appView == nil) {
        appView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, 320, [UIScreen mainScreen].bounds.size.height - 295)];
    }
    return appView;
}
@end
