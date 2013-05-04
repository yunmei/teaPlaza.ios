//
//  LoginViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginTableView;
@synthesize usernameTextField;
@synthesize passwordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"用户登陆", @"用户登陆");
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        lable.text = self.title;
        lable.textAlignment = UITextAlignmentCenter;
        [self.navigationItem setTitleView:lable];
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(userLogin)];
        self.navigationItem.rightBarButtonItem = buttonItem;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(userCancel)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if([User checkLogin])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.loginTableView];
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.passwordTextField = nil;
    self.usernameTextField = nil;
    self.loginTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
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
            [cell addSubview:self.passwordTextField];
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"马上去注册";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationController pushViewController:registerViewController animated:YES];
    }
}

- (void)userLogin
{
    if ([self.usernameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    // 开始网络请求
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"user.getSid" forKey:@"method"];
    [params setObject:self.usernameTextField.text forKey:@"username"];
    [params setObject:self.passwordTextField.text forKey:@"password"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if ([[NSString stringWithFormat:@"%@", [object objectForKey:@"errorCode"]] isEqualToString:@"0"]) {
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc]init];
            [tempDictionary setObject:[[object objectForKey:@"result"] objectForKey:@"uid"] forKey:@"userId"];
            [tempDictionary setObject:[[object objectForKey:@"result"] objectForKey:@"sid"] forKey:@"session"];
            [tempDictionary setObject:self.usernameTextField.text forKey:@"username"];
            [User saveUserInfo: tempDictionary];
            [self dismissModalViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [HUD hide:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
        [HUD hide:YES];
    }];
    [ApplicationDelegate.appEngine enqueueOperation: op];
}

- (void)userCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRespondsLogin" object:self userInfo:[NSMutableDictionary dictionaryWithObject:@"cancel" forKey:@"cancel"]];
    [self dismissModalViewControllerAnimated:YES];
}
// 初始化操作
- (UITableView *)loginTableView
{
    if (loginTableView == nil) {
        loginTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
        loginTableView.delegate = self;
        loginTableView.dataSource = self;
        loginTableView.backgroundView = nil;
        loginTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return loginTableView;
}
- (UITextField *)usernameTextField
{
    if (usernameTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        leftLabel.text = @"帐号　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        usernameTextField.placeholder = @"用户名/邮箱";
        usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        usernameTextField.leftViewMode = UITextFieldViewModeAlways;
        usernameTextField.font = [UIFont systemFontOfSize:14.0];
        usernameTextField.leftView = leftLabel;
    }
    return usernameTextField;
}
- (UITextField *)passwordTextField
{
    if (passwordTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
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
@end
