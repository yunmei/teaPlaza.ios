//
//  YMGlobal.m
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "YMGlobal.h"

@implementation YMGlobal

+ (MKNetworkOperation *)getOperation:(NSMutableDictionary *)params
{
    [params setObject:API_KEY forKey:@"apikey"];
    [params setObject:API_FORMAT forKey:@"format"];
    return [ApplicationDelegate.appEngine operationWithPath:API_BASEURL params:params httpMethod:API_METHOD ssl:NO];
}

+ (void)loadImage:(NSString *)imageUrl andImageView:(UIImageView *)imageView
{
    [ApplicationDelegate.appEngine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        [imageView setImage:fetchedImage];
    }];
}

+ (void)loadImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState
{
    [ApplicationDelegate.appEngine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        [button setBackgroundImage:fetchedImage forState:buttonState];
    }];
}

+ (void)openOtherApp:(NSString *)urlScheme andUrlLink:(NSString *)urlLink
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlScheme, @"://"]];
    if (![[UIApplication sharedApplication]openURL:url]) {
        if ([urlLink isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用正在开发中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlLink]];
    }
}
@end
