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
#import "DKUIWebViewController.h"
#import "DKWKWebViewController.h"

//#import "TOActivitySafari.h"

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
    s = @"http://www.alldk.com";
//    s = @"https://itunes.apple.com/cn/app/itranslate-converse/id1241264761?mt=8";
    
    // 判断，当前显示的控制器是否有 navi管理：有则push，无则present
    
    [WebviewCompatibleTool from:self toWebBrowserWithPush:NO url:s];
    
//   SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:s]];
//    [self presentViewController:vc animated:YES completion:nil];
//    
//    vc.delegate = self;
}


#pragma mark - ================== SFSafariViewControllerDelegate ==================

/*! @abstract Called when the view controller is about to show UIActivityViewController after the user taps the action button.
 @param URL the URL of the web page.
 @param title the title of the web page.
 @result Returns an array of UIActivity instances that will be appended to UIActivityViewController.
 */
//- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title{
//    NSLog(@"%s url:%@ title:%@", __func__, URL, title);
//    
//    return  @[[DKActivitySafari new]];
//
//}

/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    NSLog(@"%s", __func__);
}


/*! @abstract Invoked when the initial URL load is complete.
 @param success YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    NSLog(@"%s didLoadSuccessfully:%@", __func__, @(didLoadSuccessfully));

}






@end
