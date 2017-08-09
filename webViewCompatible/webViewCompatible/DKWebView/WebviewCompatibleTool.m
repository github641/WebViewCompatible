//
//  WebviewCompatibleTool.m
//  webViewCompatible
//
//  Created by alldk on 2017/8/4.
//  Copyright © 2017年 alldk. All rights reserved.
//

#import "WebviewCompatibleTool.h"
#import "DKUIWebViewController.h"
#import "DKWKWebViewController.h"

#import <SafariServices/SafariServices.h>

#define SV_GREATER_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface NSString(DK)
- (BOOL)isNotBlank;
@end

@implementation NSString(DK)

- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}


@end

@implementation WebviewCompatibleTool

//    0、url的有效性判断
//    1、运行环境检查
//    2、依据环境加载不同的 web容器
+ (void)from:(UIViewController *)from toWebBrowserWithPush:(BOOL)isPush url:(NSString *)url{
    
    if (![url isNotBlank])return;
    
    UIViewController *vc;
    
    if (SV_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        
    }else if (SV_GREATER_THAN_OR_EQUAL_TO(@"8.0")){//WKWebView
        
        // DZNWebViewController处理
//        DKWKWebViewController *tovc = [[DKWKWebViewController alloc] initWithURL:[NSURL URLWithString:url] tab:NO];
                DKUIWebViewController *tovc =  [[DKUIWebViewController alloc] initWithURLString:url];
        
        if (isPush) {
            
            vc = tovc;
        }else{
            tovc.showDoneButton = YES;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tovc];
            vc = navi;
        }
        
    }else{//UIWebView
        //         TOWebViewController的处理
        DKUIWebViewController *tovc =  [[DKUIWebViewController alloc] initWithURLString:url];
        if (isPush) {
            
            vc = tovc;
        }else{
            tovc.showDoneButton = YES;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tovc];
            vc = navi;
        }
    }
    
    
    if (isPush) {
        [from.navigationController pushViewController:vc animated:YES];
    }else{
        [from presentViewController:vc animated:YES completion:^{
        }];
    }
    
}

@end
