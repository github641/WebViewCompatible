//
//  WebviewCompatibleTool.m
//  webViewCompatible
//
//  Created by alldk on 2017/8/4.
//  Copyright © 2017年 alldk. All rights reserved.
//

#import "WebviewCompatibleTool.h"
#import "TOWebViewController.h"
#import "DZNWebViewController.h"

#import "Macro.h"

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


+ (id)showWebWithURL:(NSString *)url{
//    0、url的有效性判断
//    1、运行环境检查
//    2、依据环境加载不同的 web容器
    
    if ([url isNotBlank]) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {//SFSafariViewController
            NSLog(@"~>9.0");
        }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){//WKWebView
            NSLog(@"~>8.0");
            return [[DZNWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            
        }else{//UIWebView
            NSLog(@"~<7.0");
            return  [[TOWebViewController alloc] initWithURLString:url];
        }
        
        return nil;
    }else{
        return nil;
    }
    
}
@end
