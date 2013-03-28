//
//  RegisterViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "RegisterViewController.h"

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
    NSLog(@"注册");
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
