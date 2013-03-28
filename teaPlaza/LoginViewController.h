//
//  LoginViewController.h
//  teaPlaza
//
//  Created by bevin chen on 13-3-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *loginTableView;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@end
