//
//  ListViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-25.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "ListViewController.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "AppListCell.h"
#import "ContentViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize listTableView;
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"应用列表", @"应用列表");
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_list_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_list"]];
        [self.tabBarItem setTitle:@"应用列表"];
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
    // Add listTableView
    [self.view addSubview:self.listTableView];
    
    // 开始网络请求 dataArray
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"app.getListInfo" forKey:@"method"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
            self.dataArray = [object objectForKey:@"result"];
            [self.listTableView reloadData];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listTableView = nil;
    self.dataArray = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 186;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"listViewCell";
    AppListCell *cell = (AppListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil) {
        cell = [[AppListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell addSubview:cell.appDescLabel];
        [cell addSubview:cell.appUserNumLabel];
        [cell addSubview:cell.appImageView];
    }
    NSMutableDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    cell.appDescLabel.text = [dictionary objectForKey:@"desc"];
    cell.appUserNumLabel.text = [dictionary objectForKey:@"usenum"];
    [YMGlobal loadImage:[dictionary objectForKey:@"listimage"] andImageView:cell.appImageView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    ContentViewController *contentViewController = [[ContentViewController alloc]init];
    contentViewController.appId = [dictionary objectForKey:@"id"];
    [self.navigationController pushViewController:contentViewController animated:YES];
}

// 初始化操作
- (UITableView *)listTableView
{
    if (listTableView == nil) {
        listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 113)];
        listTableView.delegate = self;
        listTableView.dataSource = self;
        listTableView.separatorStyle = UITableViewCellAccessoryNone;
    }
    return listTableView;
}
- (NSMutableArray *)dataArray
{
    if (dataArray == nil) {
        dataArray = [[NSMutableArray alloc]init];
    }
    return dataArray;
}
@end
