//
//  ContentViewController.h
//  teaPlaza
//
//  Created by bevin chen on 13-3-25.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) UILabel *navLabel;
@property (strong, nonatomic) NSString *urlschemes;
@property (strong, nonatomic) NSString *ituneslink;
@property (strong, nonatomic) UIWebView *contentWebView;

@end
