//
//  ViewController.m
//  webView
//
//  Created by alldk on 2017/8/2.
//  Copyright © 2017年 alldk. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"] entersReaderIfAvailable:YES];
    
    [self presentViewController:sf animated:YES completion:nil];
    
    
    /* lzy注170828
     SF的导航栏、工具栏和字体颜色默认是跟随系统Safari app的。
     
     配色方案1：白色背景色，控件字体或图片颜色是蓝色，不可用状态是灰色
     配色方案2：黑色（深色）背景色，控件字体或图片颜色是白色，不可用状态是灰色
     
     系统Safari app有两种配色方案，对应正常浏览模式对应1方案，无痕浏览模式对应2方案。
     
     在无痕浏览模式下，下面的设置，对in-app SFSafariViewController不生效，还是无痕默认配色
     在正常浏览模式下，默认配色方案1，使用下面的api可以配置。
     
     以下api在iOS10才开始有
     */
    [sf setPreferredBarTintColor:[UIColor redColor]];
    
    [sf setPreferredControlTintColor:[UIColor purpleColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
