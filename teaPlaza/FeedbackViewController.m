//
//  FeedbackViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-27.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "FeedbackViewController.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize contentTextView;
@synthesize contactTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"意见反馈", @"意见反馈");
        [self.tabBarItem setTitle:@"意见反馈"];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lable.text = self.title;
        lable.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem setTitleView:lable];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(postFeedback)];
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 60)];
    [infoLabel setFont:[UIFont systemFontOfSize:14.0]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    infoLabel.text = @"欢迎提出宝贵意见和建议，您留下的每个字都将用来改善我们的软件";
    [self.view addSubview:infoLabel];
    [self.view addSubview:self.contactTextField];
    [self.view addSubview:self.contentTextView];
    [self.contentTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.contentTextView = nil;
    self.contactTextField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postFeedback
{
    if ([self.contentTextView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"意见反馈内容不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    // 开始网络请求 dataArray
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"app.getCurrentVersion" forKey:@"method"];
    [params setObject:SYS_VERSION forKey:@"version"];
    [params setObject:self.contentTextView.text forKey:@"content"];
    if (self.contactTextField.text) {
        [params setObject:self.contactTextField.text forKey:@"contact"];
    }
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if ([[object objectForKey:@"errorCode"] isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交成功，感谢您提出的意见反馈！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            self.contentTextView.text = @"";
            self.contactTextField.text = @"";
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败，是不是您的网络不稳定！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
}

- (UITextField *)contactTextField
{
    if (contactTextField == nil) {
        contactTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 175, 300, 30)];
        contactTextField.placeholder = @"留下您的联系方式";
        contactTextField.borderStyle = UITextBorderStyleNone;
        contactTextField.font = [UIFont systemFontOfSize:12.0];
        contactTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contactTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        contactTextField.backgroundColor = [UIColor whiteColor];
    }
    return contactTextField;
}

- (UITextView *)contentTextView
{
    if (contentTextView == nil) {
        contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 70, 300, 100)];
    }
    return contentTextView;
}
@end
