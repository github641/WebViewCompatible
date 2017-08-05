//
//  ViewController.m
//  webViewCompatible
//
//  Created by alldk on 2017/8/4.
//  Copyright © 2017年 alldk. All rights reserved.
//

#import "ViewController.h"

#import <SafariServices/SafariServices.h>

#import "WebviewCompatibleTool.h"
#import "TOWebViewController.h"
#import "DZNWebViewController.h"

#import "Macro.h"

@interface ViewController ()<SFSafariViewControllerDelegate>
@property (nonatomic, strong)UIViewController *vc;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *s= @"https://www.baidu.com";
        s = @"http://toutiao.eastday.com/?qid=diazh";
    
    // 判断，当前显示的控制器是否有 navi管理：有则push，无则present
    
    [WebviewCompatibleTool from:self toWebBrowserWithPush:NO url:s];
    
}






@end
