//
//  IndexViewController.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-23.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Index", @"Index");
        //self.tabBarItem.image = [UIImage imageNamed:@"Index"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Testing Button
    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 50)];
    [testButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [testButton setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:testButton];
}

- (void)clickBtn:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"com.maimaicha.chabaike://aaaaaaaaaatesttest"];
    if (![[UIApplication sharedApplication]openURL:url]) {
        NSLog(@"No Application");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
