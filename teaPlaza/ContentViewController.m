//
//  ContentViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-25.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize appId;
@synthesize navLabel;

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
    self.navLabel.text = @"内容页";
    [self.navigationItem setTitleView:self.navLabel];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.appId = nil;
    self.navLabel = nil;
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
- (UILabel *)navLabel
{
    if (navLabel == nil) {
        navLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        navLabel.backgroundColor = [UIColor clearColor];
        navLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        navLabel.font = [UIFont systemFontOfSize:20.0];
        navLabel.textAlignment = UITextAlignmentCenter;
    }
    return navLabel;
}
@end
