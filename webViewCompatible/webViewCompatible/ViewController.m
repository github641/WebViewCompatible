//
//  ViewController.m
//  webViewCompatible
//
//  Created by alldk on 2017/8/4.
//  Copyright © 2017年 alldk. All rights reserved.
//

#import "ViewController.h"
#import "WebviewCompatibleTool.h"
#import "TOWebViewController.h"
#import "DZNWebViewController.h"

#import "Macro.h"

@interface ViewController ()
@property (nonatomic, strong)UIViewController *vc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *s= @"https://www.baidu.com";
    //    s = @"http://toutiao.eastday.com/?qid=diazh";
    
    // 判断，当前显示的控制器是否有 navi管理：有则push，无则present
    
    [self toWebBrowserWithPush:NO url:s];
    
}
- (void)toWebBrowserWithPush:(BOOL)isPush url:(NSString *)url{

    
    //    self.vc =(UIViewController *) [WebviewCompatibleTool showWebWithURL:s];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {//SFSafariViewController
        NSLog(@"~>9.0");

        
    }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){//WKWebView
        NSLog(@"~>8.0");
        // DZNWebViewController处理
        DZNWebViewController *tovc = [[DZNWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
        
        
        if (isPush) {
            
            self.vc = tovc;
        }else{
            tovc.showDoneButton = YES;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tovc];
            self.vc = navi;
        }
        
        
    }else{//UIWebView
        NSLog(@"~<7.0");
        
        
        //         TOWebViewController的处理
        TOWebViewController *tovc =  [[TOWebViewController alloc] initWithURLString:url];
        if (isPush) {
            
            self.vc = tovc;
        }else{
            tovc.showDoneButton = YES;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tovc];
            self.vc = navi;
        }
    }
    
    
    //    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.vc ?:[UIViewController new]];
    
    if (isPush) {
        [self.navigationController pushViewController:self.vc animated:YES];
    }else{
        [self presentViewController:self.vc animated:YES completion:^{
            
        }];
    }
    //

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
