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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"茶广场", @"茶广场");
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_index_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_index"]];
        [self.tabBarItem setTitle:@"茶广场"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIView *tabBarBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
//    tabBarBgView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tabbar_bg"]];
//    [self.view addSubview:tabBarBgView];
//    [self.tabBar insertSubview:tabBarBgView atIndex:0];
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
    // Testing Button
    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 50)];
    [testButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [testButton setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:testButton];
}

- (void)clickBtn:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"com.maimaicha.chabaike://aaaaaaaaaatesttest"];
    if (![[UIApplication sharedApplication]openURL:url]) {
        NSLog(@"No Application");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
