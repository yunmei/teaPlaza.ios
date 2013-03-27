//
//  AppListCell.h
//  teaPlaza
//
//  Created by bevin chen on 13-3-27.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *appImageView;
@property (strong, nonatomic) UIImageView *cellBgView;
@property (strong, nonatomic) UILabel *appDescLabel;
@property (strong, nonatomic) UILabel *appUserNumLabel;

@end
