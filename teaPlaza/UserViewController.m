//
//  UserViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-25.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"

@interface UserViewController ()

@end

@implementation UserViewController

@synthesize contentTableView;
@synthesize contentDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"用户中心", @"用户中心");
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_user_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_user"]];
        [self.tabBarItem setTitle:@"用户中心"];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lable.text = self.title;
        lable.textAlignment = UITextAlignmentCenter;
        [self.navigationItem setTitleView:lable];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(userLogout)];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([User checkLogin]) {
        NSString *session = [User getSession];
        // 开始网络请求 adArray
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"user.getUserData" forKey:@"method"];
        [params setObject:session forKey:@"sid"];
        MKNetworkOperation* op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
            if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
                [self.contentDictionary setObject:[[object objectForKey:@"result"] objectForKey:@"score"] forKey:@"score"];
                [self.contentDictionary setObject:[[object objectForKey:@"result"] objectForKey:@"point"] forKey:@"point"];
                [self.contentDictionary setObject:[[object objectForKey:@"result"] objectForKey:@"diamond"] forKey:@"diamond"];
                [self.contentTableView reloadData];
            } else if ([[object objectForKey:@"errorCode"] isEqualToString:@"2"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedToLogin" object:self];
            }
            [HUD hide:YES];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"Error:%@", error);
            [HUD hide:YES];
        }];
        [ApplicationDelegate.appEngine enqueueOperation: op];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedToLogin" object:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.contentTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.contentTableView = nil;
    self.contentDictionary = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userLogout
{
    [User clearUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedToLogin" object:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 ) {
        return 3;
    }
    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@", [User getUsername], @"，您好！"];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", @"游戏钻石：", [self.contentDictionary objectForKey:@"diamond"]];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", @"社区积分：", [self.contentDictionary objectForKey:@"score"]];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", @"商城买币：", [self.contentDictionary objectForKey:@"point"]];
        }
    }
    return cell;
}

// 初始化操作
- (UITableView *)contentTableView
{
    if (contentTableView == nil) {
        contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        contentTableView.backgroundView = nil;
        contentTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return contentTableView;
}

- (NSMutableDictionary *)contentDictionary
{
    if (contentDictionary == nil) {
        contentDictionary = [[NSMutableDictionary alloc]init];
        [contentDictionary setObject:@"0" forKey:@"score"];
        [contentDictionary setObject:@"0" forKey:@"point"];
        [contentDictionary setObject:@"0" forKey:@"diamond"];
    }
    return contentDictionary;
}
@end
