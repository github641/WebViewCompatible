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
    s = @"http://toutiao.eastday.com/?qid=diazh";
    
//    self.vc =(UIViewController *) [WebviewCompatibleTool showWebWithURL:s];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {//SFSafariViewController
        NSLog(@"~>9.0");
    }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){//WKWebView
        NSLog(@"~>8.0");
        self.vc = [[DZNWebViewController alloc] initWithURL:[NSURL URLWithString:s]];
        
//        self.vc = [[TOWebViewController alloc] initWithURLString:s];
        
    }else{//UIWebView
        NSLog(@"~<7.0");
self.vc = [[TOWebViewController alloc] initWithURLString:s];
    }

    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.vc ?:[UIViewController new]];
    [self presentViewController:navi animated:YES completion:^{
        
        
        
    }];
//    [self.navigationController pushViewController:self.vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
