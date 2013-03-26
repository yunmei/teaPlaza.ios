//
//  ContentViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-25.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "ContentViewController.h"
#import "YMGlobal.h"
#import "MBProgressHUD.h"
#import "SBJson.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize appId;
@synthesize navLabel;
@synthesize ituneslink;
@synthesize urlschemes;
@synthesize contentWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打开应用" style:UIBarButtonItemStyleBordered target:self action:@selector(goToApp)];
    [self.navigationItem setTitleView:self.navLabel];
    self.navLabel.text = @"内容页";
    
    // Add contentWebView
    [self.view addSubview:self.contentWebView];
    
    // 开始网络请求 appContent
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"app.getAppContent" forKey:@"method"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        NSLog(@"object:%@",object);
        if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
            NSMutableDictionary *o = [object objectForKey:@"result"];
            self.ituneslink = [o objectForKey:@"ituneslink"];
            self.urlschemes = [o objectForKey:@"urlschemes"];
            self.navLabel.text = [o objectForKey:@"name"];
            [self.contentWebView loadHTMLString:[o objectForKey:@"html"] baseURL:nil];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
}

- (void)goToApp
{
    [YMGlobal openOtherApp:self.urlschemes andUrlLink:self.ituneslink];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.appId = nil;
    self.navLabel = nil;
    self.urlschemes = nil;
    self.ituneslink = nil;
    self.contentWebView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化操作
- (NSString *)appId
{
    if (appId == nil) {
        appId = @"";
    }
    return appId;
}
- (NSString *)urlschemes
{
    if (urlschemes == nil) {
        urlschemes = @"";
    }
    return urlschemes;
}
- (NSString *)ituneslink
{
    if (ituneslink == nil) {
        ituneslink = @"";
    }
    return ituneslink;
}
- (UILabel *)navLabel
{
    if (navLabel == nil) {
        navLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        navLabel.backgroundColor = [UIColor clearColor];
        navLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        navLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        navLabel.textAlignment = UITextAlignmentCenter;
    }
    return navLabel;
}
- (UIWebView *)contentWebView
{
    if (contentWebView == nil) {
        contentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 113)];
        contentWebView.scrollView.bounces = NO;
    }
    return contentWebView;
}
@end
