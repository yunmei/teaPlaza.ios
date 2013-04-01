//
//  RegisterViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize registerTableView;
@synthesize usernameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize rePasswordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"用户注册", @"用户注册");
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lable.text = self.title;
        lable.textAlignment = UITextAlignmentCenter;
        [self.navigationItem setTitleView:lable];
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(userRegister)];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.registerTableView];
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.registerTableView = nil;
    self.usernameTextField = nil;
    self.emailTextField = nil;
    self.passwordTextField = nil;
    self.rePasswordTextField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell addSubview:self.usernameTextField];
        } else if (indexPath.row == 1) {
            [cell addSubview:self.emailTextField];
        } else if (indexPath.row == 2) {
            [cell addSubview:self.passwordTextField];
        } else if (indexPath.row == 3) {
            [cell addSubview:self.rePasswordTextField];
        }
    }
    return cell;
}

- (void)userRegister
{
    if ([self.usernameTextField.text isEqualToString:@""]) {
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if ([self.usernameTextField.text length] < 4 || [self.usernameTextField.text length] > 20) {
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名的长度应该为4-20个字符！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    if ([self.emailTextField.text isEqualToString:@""]) {
        [self.emailTextField becomeFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    NSString *regEx = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSRange r = [self.emailTextField.text rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location == NSNotFound) {
        [self.emailTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您填写的邮箱不正确！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [self.passwordTextField becomeFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if (![self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]) {
        [self.rePasswordTextField becomeFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    // 开始网络请求
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"user.register" forKey:@"method"];
    [params setObject:self.usernameTextField.text forKey:@"username"];
    [params setObject:self.emailTextField.text forKey:@"email"];
    [params setObject:self.passwordTextField.text forKey:@"password"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        NSLog(@"object:%@", object);
        if ([[NSString stringWithFormat:@"%@", [object objectForKey:@"errorCode"]] isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功，马上登陆！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([[NSString stringWithFormat:@"%@", [object objectForKey:@"errorCode"]] isEqualToString:@"401"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名已存在，请换用户重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else if ([[NSString stringWithFormat:@"%@", [object objectForKey:@"errorCode"]] isEqualToString:@"402"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱已存在，请更换邮箱重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
}

// 初始化操作
- (UITableView *)registerTableView
{
    if (registerTableView == nil) {
        registerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
        registerTableView.delegate = self;
        registerTableView.dataSource = self;
        registerTableView.backgroundView = nil;
        registerTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return registerTableView;
}
- (UITextField *)usernameTextField
{
    if (usernameTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        leftLabel.text = @"用户名　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        usernameTextField.placeholder = @"用户名";
        usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        usernameTextField.leftViewMode = UITextFieldViewModeAlways;
        usernameTextField.font = [UIFont systemFontOfSize:14.0];
        usernameTextField.leftView = leftLabel;
    }
    return usernameTextField;
}
- (UITextField *)emailTextField
{
    if (emailTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        leftLabel.text = @"邮箱　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        emailTextField.placeholder = @"邮箱";
        emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        emailTextField.leftViewMode = UITextFieldViewModeAlways;
        emailTextField.font = [UIFont systemFontOfSize:14.0];
        emailTextField.leftView = leftLabel;
    }
    return emailTextField;
}
- (UITextField *)passwordTextField
{
    if (passwordTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        leftLabel.text = @"密码　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        passwordTextField.placeholder = @"密码";
        passwordTextField.secureTextEntry = YES;
        passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        passwordTextField.font = [UIFont systemFontOfSize:14.0];
        passwordTextField.leftView = leftLabel;
    }
    return passwordTextField;
}
- (UITextField *)rePasswordTextField
{
    if (rePasswordTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        leftLabel.text = @"确认密码　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        rePasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        rePasswordTextField.placeholder = @"密码";
        rePasswordTextField.secureTextEntry = YES;
        rePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        rePasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        rePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        rePasswordTextField.font = [UIFont systemFontOfSize:14.0];
        rePasswordTextField.leftView = leftLabel;
    }
    return rePasswordTextField;
}
@end
