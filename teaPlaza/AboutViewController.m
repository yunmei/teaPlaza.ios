//
//  AboutViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-25.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AboutViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "UMSocialSnsService.h"
#import "FeedbackViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize contentTableView;
@synthesize newVersion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"关于我们", @"关于我们");
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_about_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_about"]];
        [self.tabBarItem setTitle:@"关于我们"];
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
    [self.view addSubview:self.contentTableView];
    self.newVersion = NO;
    // 开始网络请求 dataArray
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"app.getCurrentVersion" forKey:@"method"];
    [params setObject:SYS_VERSION forKey:@"version"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
            NSString *update = [NSString stringWithFormat:@"%@", [[object objectForKey:@"result"]objectForKey:@"update"]];
            if ([update isEqualToString:@"YES"]) {
                self.newVersion = YES;
                [self.contentTableView reloadData];
            }
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
    self.contentTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }
    }
    return 50.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, 95)];
                [infoLabel setFont:[UIFont systemFontOfSize:14.0]];
                [infoLabel setBackgroundColor:[UIColor clearColor]];
                infoLabel.numberOfLines = 0;
                infoLabel.lineBreakMode = UILineBreakModeCharacterWrap;
                infoLabel.text = @"　　茶广场是山东华夏茶联茶业有限公司开发的一款茶行业多功能平台软件，包括茶百科、开心茶园、单店ERP、买买茶等多款茶行业应用。即刻下载，与众多茶叶爱好者（茶叶经营者）共同体验精品应用！";
                [cell addSubview:infoLabel];
            } else if (indexPath.row == 1) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 30)];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [label setBackgroundColor:[UIColor clearColor]];
                if (self.newVersion) {
                    label.text = [NSString stringWithFormat:@"%@%@%@", @"软件版本", SYS_VERSION, @" （有新版本，马上升级）"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                } else {
                    label.text = [NSString stringWithFormat:@"%@%@%@", @"软件版本", SYS_VERSION, @" （已是最新版本）"];
                }
                [cell addSubview:label];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 30)];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [label setBackgroundColor:[UIColor clearColor]];
                label.text = @"喜欢我们，打5星鼓励";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell addSubview:label];
            } else if (indexPath.row == 1) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 30)];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [label setBackgroundColor:[UIColor clearColor]];
                label.text = @"意见反馈";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell addSubview:label];
            } else if (indexPath.row == 2) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 30)];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [label setBackgroundColor:[UIColor clearColor]];
                label.text = @"我要分享给朋友";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell addSubview:label];
            }
        }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        [UMSocialSnsService presentSnsController:self
                                          appKey:UM_BAIKE_APPKEY
                                       shareText:UM_SHARETEXT
                                      shareImage:nil
                                 shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToRenren,UMShareToQzone,UMShareToDouban,UMShareToTencent,UMShareToSina,nil]
                                        delegate:nil];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SYS_APPLINK]];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.newVersion) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SYS_APPLINK]];
        }
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    }
}

- (UITableView *)contentTableView
{
    if (contentTableView == nil) {
        contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 113) style:UITableViewStyleGrouped];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        contentTableView.backgroundView = nil;
        contentTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return contentTableView;
}
@end
