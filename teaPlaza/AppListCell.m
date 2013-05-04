//
//  AppListCell.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-27.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AppListCell.h"

@implementation AppListCell
@synthesize appDescLabel;
@synthesize appImageView;
@synthesize appUserNumLabel;
@synthesize cellBgView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellBgView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)appUserNumLabel
{
    if (appUserNumLabel == nil) {
        appUserNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 140, 50, 30)];
        [appUserNumLabel setTextAlignment:NSTextAlignmentRight];
        [appUserNumLabel setFont:[UIFont systemFontOfSize:12.0]];
        [appUserNumLabel setBackgroundColor:[UIColor clearColor]];
        [appUserNumLabel setTextColor:[UIColor grayColor]];
        [appUserNumLabel setText:@"0"];
    }
    return appUserNumLabel;
}
- (UILabel *)appDescLabel
{
    if (appDescLabel == nil) {
        appDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 220, 30)];
        [appDescLabel setFont:[UIFont systemFontOfSize:14.0]];
        [appDescLabel setBackgroundColor:[UIColor clearColor]];
    }
    return appDescLabel;
}
- (UIImageView *)appImageView
{
    if (appImageView == nil) {
        appImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 280, 120)];
    }
    return appImageView;
}
- (UIImageView *)cellBgView
{
    if (cellBgView == nil) {
        cellBgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 290, 166)];
        [cellBgView setImage:[UIImage imageNamed:@"cell_bg"]];
    }
    return cellBgView;
}
@end
