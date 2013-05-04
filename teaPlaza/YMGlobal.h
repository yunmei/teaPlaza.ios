//
//  YMGlobal.h
//
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AppDelegate.h"

@interface YMGlobal : NSObject

// 获取MKNetworkOperation
+ (MKNetworkOperation *)getOperation:(NSMutableDictionary *)params;

// 加载图片
+ (void)loadImage:(NSString *)imageUrl andImageView:(UIImageView *)imageView;
+ (void)loadImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState;

// 打开其它应用
+ (void)openOtherApp:(NSString *)urlScheme andUrlLink:(NSString *)urlLink;
@end
