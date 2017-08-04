//
//  TOViewController.m
//  TOWebViewControllerExample
//
//  Created by Tim Oliver on 6/05/13.
//  Copyright (c) 2013 Tim Oliver. All rights reserved.
//

#import "TOViewController.h"

#import "TOWebViewController.h"


/* lzy注170802：
 NSObjCRuntime.h中定义的宏
 */
#ifndef NSFoundationVersionNumber_iOS_6_1
    #define NSFoundationVersionNumber_iOS_6_1  993.00
#endif

/* Detect if we're running iOS 7.0 or higher */
#define MINIMAL_UI (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

@interface TOViewController ()

@end

@implementation TOViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"TOWebViewController";
    
    // 判断当前的iOS版本来写界面
    if (MINIMAL_UI) {
        self.tableView.backgroundView = [UIView new];
        self.view.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        self.tableView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.tableView.backgroundView = [UIView new];
            self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    // viewDidLoad时，清理之前的cookies
#ifdef TO_ONEPASSWORD_EXAMPLE
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
}

#pragma mark - Table View Protocols -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Present as Modal View Controller";
    }
    else {
        cell.textLabel.text = @"Push onto Navigation Controller";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *url = nil;
    /* lzy注170802：
     TOWebViewController+1Password这个target做了设置：
     在Target -> Build Setting -> Apple LLVM 8.1 - Preprocessing中
     Preprocessor Macros
     中添加的TO_ONEPASSWORD_EXAMPLE=1，
     而其他target的编译设置里没有设置。
     */
    
    // 决定url
#ifdef TO_ONEPASSWORD_EXAMPLE
    url = [NSURL URLWithString:@"https://accounts.google.com/login"];
#else
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        url = [NSURL URLWithString:@"www.apple.com/ipad"];
    else if ([[[UIDevice currentDevice] model] rangeOfString:@"iPod"].location != NSNotFound)
        url = [NSURL URLWithString:@"www.apple.com/ipod-touch"];
    else
        url = [NSURL URLWithString:@"www.apple.com/iphone"];
#endif
    // 根据给定URL创建 TOWeb vc
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
#ifdef TO_ONEPASSWORD_EXAMPLE
    webViewController.showOnePasswordButton = YES;
#endif

// Uncomment this if you want to test out placing buttons permanently in the left hand side of the navigation bar
//    UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
//    webViewController.applicationLeftBarButtonItems = @[testItem];
    
    // 一个present一个push，README中说，TOWeb view非常智能，不管怎么跳转的，它的UI都是做好了调整的。
    if (indexPath.row == 0) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
    }
    else {
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

@end
