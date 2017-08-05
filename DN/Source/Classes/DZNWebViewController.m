//
//  DZNWebViewController.m
//  DZNWebViewController
//  https://github.com/dzenbot/DZNWebViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/25/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNWebViewController.h"
#import "UIImage+TOWebViewControllerIcons.h"
#import "TOActivitySafari.h"
//#import "DZNPolyActivity.h"
#define DZN_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define DZN_IS_LANDSCAPE ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

static char DZNWebViewControllerKVOContext = 0;

#pragma mark - ================== DZNWebView ==================

@implementation DZNWebView

- (void)setNavDelegate:(id<DZNNavigationDelegate>)delegate
{
    if (!delegate || (self.navDelegate && ![self.navDelegate isEqual:delegate])) {
        [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    if (delegate) {
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    }
    
    _navDelegate = delegate;
    
    [super setNavigationDelegate:delegate];
}


// Key Value Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self] && [keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))])
    {
        if (self.navDelegate && [self.navDelegate respondsToSelector:@selector(webView:didUpdateProgress:)]) {
            [self.navDelegate webView:self didUpdateProgress:self.estimatedProgress];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
#pragma mark - ================== DZNWebView ==================

#pragma mark - ================== DZNWebViewController ==================
@interface DZNWebViewController ()
/* lzy注170805：
 TO done btn 移植
 */
@property (nonatomic,strong) UIBarButtonItem *doneButton;             /* The 'Done' button for modal contorllers */
@property (nonatomic,readonly) BOOL beingPresentedModally;            /* The controller was presented as a modal popup (eg, 'Done' button) */
@property (nonatomic,readonly) BOOL onTopOfNavigationControllerStack; /* We're in, and not the root of a UINavigationController (eg, 'Back' button)*/

@property (nonatomic, strong) UIBarButtonItem *backwardBarItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarItem;
@property (nonatomic, strong) UIBarButtonItem *stateBarItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarItem;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILongPressGestureRecognizer *backwardLongPress;
@property (nonatomic, strong) UILongPressGestureRecognizer *forwardLongPress;

@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UINavigationBar *navigationBar;
@property (nonatomic, weak) UIView *navigationBarSuperView;

@property (nonatomic) BOOL completedInitialLoad;

@end

@implementation DZNWebViewController
@synthesize URL = _URL;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    NSParameterAssert(URL);

    self = [self init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (instancetype)initWithFileURL:(NSURL *)URL
{
    return [self initWithURL:URL];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    self.supportedWebNavigationTools = DZNWebNavigationToolAll;
    self.supportedWebActions = DZNWebActionAll;
    self.webNavigationPrompt = DZNWebNavigationPromptAll;
    self.showLoadingProgress = YES;
    self.hideBarsWithGestures = YES;
    self.allowHistory = YES;
    
    self.webView = [[DZNWebView alloc] initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.UIDelegate = self;
    self.webView.navDelegate = self;
    self.webView.scrollView.delegate = self;
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
    self.completedInitialLoad = NO;
    /* lzy注170805：
     TO 的 done btn
     */
    self.showDoneButton = YES;
}


#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view = self.webView;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* lzy注170805：
     TO done btn 移植
     */
    [self createDoneBtn];
}

- (BOOL)onTopOfNavigationControllerStack
{
    if (self.navigationController == nil)
        return NO;
    
    if ([self.navigationController.viewControllers count] && [self.navigationController.viewControllers indexOfObject:self] > 0)
        return YES;
    
    return NO;
}
- (BOOL)beingPresentedModally
{
    // Check if we have a parent navigation controller, it's being presented modally,
    // and if it is, that we are its root view controller
    if (self.navigationController && self.navigationController.presentingViewController)
        return ([self.navigationController.viewControllers indexOfObject:self] == 0);
    else // Check if we're being presented modally directly
        return ([self presentingViewController] != nil);
    
    return NO;
}
- (void)doneButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createDoneBtn{
    // Create the Done button
    if (self.showDoneButton && self.beingPresentedModally && !self.onTopOfNavigationControllerStack) {
        if (self.doneButtonTitle) {
            self.doneButton = [[UIBarButtonItem alloc] initWithTitle:self.doneButtonTitle style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(doneButtonTapped:)];
        }
        else {
            self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                            target:self
                                                                            action:@selector(doneButtonTapped:)];
        }
        
    }

}

- (void)addDoneBtn{
    //Layout the buttons
    [UIView performWithoutAnimation:^{
        // Set up the Done button if presented modally
        if (self.doneButton) {
            self.navigationItem.rightBarButtonItem = self.doneButton;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.completedInitialLoad) {
        
        [UIView performWithoutAnimation:^{
            [self configureToolBars];
        }];
        self.completedInitialLoad = YES;
    }
    
    if (!self.webView.URL) {
        [self loadURL:self.URL];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t didAppearConfig;
    dispatch_once(&didAppearConfig, ^{
        [self configureBarItemsGestures];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [self clearProgressViewAnimated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [self.webView stopLoading];
}


#pragma mark - Getter methods

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        CGFloat lineHeight = 2.0f;
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.navigationBar.bounds) - lineHeight, CGRectGetWidth(self.navigationBar.bounds), lineHeight);
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:frame];
        progressView.trackTintColor = [UIColor clearColor];
        progressView.alpha = 0.0f;
        
        [self.navigationBar addSubview:progressView];
        
        _progressView = progressView;
    }
    return _progressView;
}

- (UIBarButtonItem *)backwardBarItem
{
    if (!_backwardBarItem)
    {
        _backwardBarItem = [[UIBarButtonItem alloc] initWithImage:[self backwardButtonImage] landscapeImagePhone:nil style:0 target:self action:@selector(goBackward:)];
        _backwardBarItem.accessibilityLabel = @"后退";
        _backwardBarItem.enabled = NO;
    }
    return _backwardBarItem;
}

- (UIBarButtonItem *)forwardBarItem
{
    if (!_forwardBarItem)
    {
        _forwardBarItem = [[UIBarButtonItem alloc] initWithImage:[self forwardButtonImage] landscapeImagePhone:nil style:0 target:self action:@selector(goForward:)];
        _forwardBarItem.landscapeImagePhone = nil;
        _forwardBarItem.accessibilityLabel = @"前进";
        _forwardBarItem.enabled = NO;
    }
    return _forwardBarItem;
}

- (UIBarButtonItem *)stateBarItem
{
    if (!_stateBarItem)
    {
        _stateBarItem = [[UIBarButtonItem alloc] initWithImage:nil landscapeImagePhone:nil style:0 target:nil action:nil];
        [self updateStateBarItem];
    }
    return _stateBarItem;
}

- (UIBarButtonItem *)actionBarItem
{
    if (!_actionBarItem)
    {
        _actionBarItem = [[UIBarButtonItem alloc] initWithImage:[self actionButtonImage] landscapeImagePhone:nil style:0 target:self action:@selector(presentActivityController:)];
        _actionBarItem.accessibilityLabel = @"分享";
        _actionBarItem.enabled = NO;
    }
    return _actionBarItem;
}

- (NSArray *)navigationToolItems
{
    NSMutableArray *items = [NSMutableArray new];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    if ((self.supportedWebNavigationTools & DZNWebNavigationToolBackward) > 0 || self.supportsAllNavigationTools) {
        [items addObject:self.backwardBarItem];
    }
    
    if ((self.supportedWebNavigationTools & DZNWebNavigationToolForward) > 0 || self.supportsAllNavigationTools) {
        if (!DZN_IS_IPAD) [items addObject:flexibleSpace];
        [items addObject:self.forwardBarItem];
    }
    
    if ((self.supportedWebNavigationTools & DZNWebNavigationToolStopReload) > 0 || self.supportsAllNavigationTools) {
        if (!DZN_IS_IPAD) [items addObject:flexibleSpace];
        [items addObject:self.stateBarItem];
    }
    
    if (self.supportedWebActions > 0) {
        if (!DZN_IS_IPAD) [items addObject:flexibleSpace];
        [items addObject:self.actionBarItem];
    }
    
    return items;
}

- (BOOL)supportsAllNavigationTools
{
    return (_supportedWebNavigationTools == DZNWebNavigationToolAll) ? YES : NO;
}

- (UIImage *)backwardButtonImage
{
    if (!_backwardButtonImage) {
        _backwardButtonImage = [UIImage TOWebViewControllerIcon_backButtonWithAttributes:@{}];
    }
    return _backwardButtonImage;
}

- (UIImage *)forwardButtonImage
{
    if (!_forwardButtonImage) {
        _forwardButtonImage = [UIImage TOWebViewControllerIcon_forwardButtonWithAttributes:@{}];
    }
    return _forwardButtonImage;
}

- (UIImage *)reloadButtonImage
{
    if (!_reloadButtonImage) {
        _reloadButtonImage = [UIImage TOWebViewControllerIcon_refreshButtonWithAttributes:@{}];
    }
    return _reloadButtonImage;
}

- (UIImage *)stopButtonImage
{
    if (!_stopButtonImage) {
        _stopButtonImage = [UIImage TOWebViewControllerIcon_stopButtonWithAttributes:@{}];
    }
    return _stopButtonImage;
}

- (UIImage *)actionButtonImage
{
    if (!_actionButtonImage) {
        _actionButtonImage = [UIImage TOWebViewControllerIcon_actionButtonWithAttributes:@{}];
    }
    return _actionButtonImage;
}

- (NSArray *)applicationActivitiesForItem:(id)item
{
    NSMutableArray *activities = [NSMutableArray new];
    
    if ([item isKindOfClass:[UIImage class]]) {
        return activities;
    }
    
    
 
    if ((_supportedWebActions & DZNWebActionOpenSafari) || self.supportsAllActions) {
        [activities addObject:[TOActivitySafari new]];
    }

    
    return activities;
}

//- (NSArray *)excludedActivityTypesForItem:(id)item
//{
//    NSMutableArray *types = [NSMutableArray new];
//    
//    if (![item isKindOfClass:[UIImage class]]) {
//        [types addObjectsFromArray:@[UIActivityTypeCopyToPasteboard,
//                                     UIActivityTypeSaveToCameraRoll,
//                                     UIActivityTypePostToFlickr,
//                                     UIActivityTypePrint,
//                                     UIActivityTypeAssignToContact]];
//    }
//    
//    if (self.supportsAllActions) {
//        return types;
//    }
//    
//    if ((_supportedWebActions & DZNsupportedWebActionshareLink) == 0) {
//        [types addObjectsFromArray:@[UIActivityTypeMail, UIActivityTypeMessage,
//                                     UIActivityTypePostToFacebook, UIActivityTypePostToTwitter,
//                                     UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo,
//                                     UIActivityTypeAirDrop]];
//    }
//    if ((_supportedWebActions & DZNWebActionReadLater) == 0 && [item isKindOfClass:[UIImage class]]) {
//        [types addObject:UIActivityTypeAddToReadingList];
//    }
//    
//    return types;
//}

- (BOOL)supportsAllActions
{
    return (_supportedWebActions == DZNWebActionAll) ? YES : NO;
}


#pragma mark - Setter methods

- (void)setURL:(NSURL *)URL
{
    if ([self.URL isEqual:URL]) {
        return;
    }
    
    if (self.isViewLoaded) {
        [self loadURL:URL];
    }
    
    _URL = URL;
}

- (void)setTitle:(NSString *)title
{
    if (self.webNavigationPrompt == DZNWebNavigationPromptNone) {
        [super setTitle:title];
        return;
    }
    
    NSString *url = self.webView.URL.absoluteString;
    
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    
    if (!label || ![label isKindOfClass:[UILabel class]]) {
        label = [UILabel new];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.navigationItem.titleView = label;
    }
    
    UIFont *titleFont = self.navigationBar.titleTextAttributes[NSFontAttributeName] ? : [UIFont boldSystemFontOfSize:14.0];
    UIFont *urlFont = [UIFont fontWithName:titleFont.fontName size:titleFont.pointSize-2.0];
    UIColor *textColor = self.navigationBar.titleTextAttributes[NSForegroundColorAttributeName] ? : [UIColor blackColor];
    
    NSMutableString *text = [NSMutableString new];
    
    if (title.length > 0 && self.showNavigationPromptTitle) {
        [text appendFormat:@"%@", title];
        
        if (url.length > 0 && self.showNavigationPromptURL) {
            [text appendFormat:@"\n"];
        }
    }
    
    if (url.length > 0 && self.showNavigationPromptURL) {
        [text appendFormat:@"%@", url];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: titleFont, NSForegroundColorAttributeName: textColor};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSRange urlRange = [text rangeOfString:url];

    if (urlRange.location != NSNotFound && self.showNavigationPromptTitle) {
        [attributedString addAttribute:NSFontAttributeName value:urlFont range:urlRange];
    }
    
    label.attributedText = attributedString;
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.size.height = CGRectGetHeight(self.navigationController.navigationBar.frame);
    label.frame = frame;
}

// Sets the request errors with an alert view.
- (void)setLoadingError:(NSError *)error
{
    switch (error.code) {
        case NSURLErrorUnknown:
        case NSURLErrorCancelled:   return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
}

- (BOOL)showNavigationPromptTitle
{
    if ((self.webNavigationPrompt & DZNWebNavigationPromptTitle) > 0 || self.webNavigationPrompt == DZNWebNavigationPromptAll) {
        return YES;
    }
    return NO;
}

- (BOOL)showNavigationPromptURL
{
    if ((self.webNavigationPrompt & DZNWebNavigationPromptURL) > 0 || self.webNavigationPrompt == DZNWebNavigationPromptAll) {
        return YES;
    }
    return NO;
}


#pragma mark - DZNWebViewController methods

- (void)loadURL:(NSURL *)URL
{
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:URL.path.stringByDeletingLastPathComponent isDirectory:YES];
    [self loadURL:URL baseURL:baseURL];
}

- (void)loadURL:(NSURL *)URL baseURL:(NSURL *)baseURL
{
    if ([URL isFileURL]) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
        NSString *HTMLString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];

        [self.webView loadHTMLString:HTMLString baseURL:baseURL];
    }
    else {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        [self.webView loadRequest:request];
    }
}

- (void)goBackward:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)goForward:(id)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)dismissHistoryController
{
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            
            // The bar button item's gestures are invalidated after using them, so we must re-assign them.
            [self configureBarItemsGestures];
        }];
    }
}

- (void)showBackwardHistory:(UIGestureRecognizer *)sender
{
    if (!self.allowHistory || self.webView.backForwardList.backList.count == 0 || sender.state != UIGestureRecognizerStateBegan) {
        return;
    }

    [self presentHistoryControllerForTool:DZNWebNavigationToolBackward fromView:sender.view];
}

- (void)showForwardHistory:(UIGestureRecognizer *)sender
{
    if (!self.allowHistory || self.webView.backForwardList.forwardList.count == 0 || sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self presentHistoryControllerForTool:DZNWebNavigationToolForward fromView:sender.view];
}

- (void)presentHistoryControllerForTool:(DZNWebNavigationTools)tool fromView:(UIView *)view
{
    UITableViewController *controller = [UITableViewController new];
    controller.title = @"历史纪录";
    controller.tableView.delegate = self;
    controller.tableView.dataSource = self;
    controller.tableView.tag = tool;
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissHistoryController)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    UIView *bar = DZN_IS_IPAD ? self.navigationBar : self.toolbar;
    
    if (DZN_IS_IPAD) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        [popover presentPopoverFromRect:view.frame inView:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (void)configureToolBars
{
    if (DZN_IS_IPAD) {
        self.navigationItem.rightBarButtonItems = [[[self navigationToolItems] reverseObjectEnumerator] allObjects];
    }
    else {
        [self setToolbarItems:[self navigationToolItems]];
        /* lzy注170805：
         添加done btn
         */
        [self addDoneBtn];
    }
    
    self.toolbar = self.navigationController.toolbar;
    self.navigationBar = self.navigationController.navigationBar;
    self.navigationBarSuperView = self.navigationBar.superview;
    
    self.navigationController.hidesBarsOnSwipe = self.hideBarsWithGestures;
    self.navigationController.hidesBarsWhenKeyboardAppears = self.hideBarsWithGestures;
    self.navigationController.hidesBarsWhenVerticallyCompact = self.hideBarsWithGestures;

    if (self.hideBarsWithGestures) {
        [self.navigationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
        [self.navigationBar addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
        [self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
    }

    if (!DZN_IS_IPAD && self.navigationController.toolbarHidden && self.toolbarItems.count > 0) {
        [self.navigationController setToolbarHidden:NO];
    }
}

// Light hack for adding custom gesture recognizers to UIBarButtonItems
- (void)configureBarItemsGestures
{
    UIView *backwardButton= [self.backwardBarItem valueForKey:@"view"];
    if (backwardButton.gestureRecognizers.count == 0) {
        if (!_backwardLongPress) {
            _backwardLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showBackwardHistory:)];
        }
        [backwardButton addGestureRecognizer:self.backwardLongPress];
    }
    
    UIView *forwardBarButton= [self.forwardBarItem valueForKey:@"view"];
    if (forwardBarButton.gestureRecognizers.count == 0) {
        if (!_forwardLongPress) {
            _forwardLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showForwardHistory:)];
        }
        [forwardBarButton addGestureRecognizer:self.forwardLongPress];
    }
}

- (void)updateToolbarItems
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self.webView isLoading]];

    self.backwardBarItem.enabled = [self.webView canGoBack];
    self.forwardBarItem.enabled = [self.webView canGoForward];
    
    self.actionBarItem.enabled = !self.webView.isLoading;
    
    [self updateStateBarItem];
}

- (void)updateStateBarItem
{
    self.stateBarItem.target = self.webView;
    self.stateBarItem.action = self.webView.isLoading ? @selector(stopLoading) : @selector(reload);
    self.stateBarItem.image = self.webView.isLoading ? self.stopButtonImage : self.reloadButtonImage;
    self.stateBarItem.landscapeImagePhone = nil;
    self.stateBarItem.accessibilityLabel = self.webView.isLoading ? @"停止" : @"刷新";
    self.stateBarItem.enabled = YES;
}

- (void)presentActivityController:(id)sender
{
    if (!self.webView.URL.absoluteString) {
        return;
    }
    
//    [self presentActivityControllerWithItem:self.webView.URL.absoluteString andTitle:self.webView.title sender:sender];
    
    if (NSClassFromString(@"UIPresentationController")) {
        NSArray *browserActivities = @[[TOActivitySafari new]];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.URL] applicationActivities:browserActivities];
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        activityViewController.popoverPresentationController.barButtonItem = sender;
        activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList];
        [self presentViewController:activityViewController animated:YES completion:nil];
    
    }
    
}

- (void)presentActivityControllerWithItem:(id)item andTitle:(NSString *)title sender:(id)sender
{
    if (!item) {
        return;
    }
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[title, item] applicationActivities:[self applicationActivitiesForItem:item]];
//    controller.excludedActivityTypes = [self excludedActivityTypesForItem:item];
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.popoverPresentationController.barButtonItem = sender;
    if (title) {
        [controller setValue:title forKey:@"subject"];
    }
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        controller.popoverPresentationController.barButtonItem = sender;
//    }
    
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)clearProgressViewAnimated:(BOOL)animated
{
    if (!_progressView) {
        return;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^{
                         self.progressView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self destroyProgressViewIfNeeded];
                     }];
}

- (void)destroyProgressViewIfNeeded
{
    if (_progressView) {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
}


#pragma mark - DZNNavigationDelegate methods

- (void)webView:(DZNWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self updateStateBarItem];
}

- (void)webView:(DZNWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self.webView isLoading]];
}

- (void)webView:(DZNWebView *)webView didUpdateProgress:(CGFloat)progress
{
    if (!self.showLoadingProgress) {
        [self destroyProgressViewIfNeeded];
        return;
    }
    
    if (self.progressView.alpha == 0 && progress > 0) {
        
        self.progressView.progress = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.alpha = 1.0;
        }];
    }
    else if (self.progressView.alpha == 1.0 && progress == 1.0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.progressView.progress = 0;
        }];
    }
    
    [self.progressView setProgress:progress animated:YES];
}

- (void)webView:(DZNWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.webNavigationPrompt > DZNWebNavigationPromptNone) {
        self.title = self.webView.title;
    }
}

- (void)webView:(DZNWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self setLoadingError:error];
    
    // if this is a cancelled error, then don't affect the title
    switch (error.code) {
        case NSURLErrorCancelled:   return;
    }

    self.title = nil;
}


#pragma mark - WKUIDelegate methods

- (DZNWebView *)webView:(DZNWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == DZNWebNavigationToolBackward) {
        return self.webView.backForwardList.backList.count;
    }
    if (tableView.tag == DZNWebNavigationToolForward) {
        return self.webView.backForwardList.forwardList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    WKBackForwardListItem *item = nil;
    
    if (tableView.tag == DZNWebNavigationToolBackward) {
        item = [self.webView.backForwardList.backList objectAtIndex:indexPath.row];
    }
    if (tableView.tag == DZNWebNavigationToolForward) {
        item = [self.webView.backForwardList.forwardList objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [item.URL absoluteString];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKBackForwardListItem *item = nil;
    
    if (tableView.tag == DZNWebNavigationToolBackward) {
        item = [self.webView.backForwardList.backList objectAtIndex:indexPath.row];
    }
    if (tableView.tag == DZNWebNavigationToolForward) {
        item = [self.webView.backForwardList.forwardList objectAtIndex:indexPath.row];
    }
    
    [self.webView goToBackForwardListItem:item];
    
    [self dismissHistoryController];
}


#pragma mark - Key Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != &DZNWebViewControllerKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([object isEqual:self.navigationBar]) {
        
        // Skips for landscape orientation, since there is no status bar visible on iPhone landscape
        if (DZN_IS_LANDSCAPE) {
            return;
        }
        
        id new = change[NSKeyValueChangeNewKey];
        
        if ([keyPath isEqualToString:@"hidden"] && [new boolValue] && self.navigationBar.center.y >= -2.0) {
            
            self.navigationBar.hidden = NO;
            
            if (!self.navigationBar.superview) {
                [self.navigationBarSuperView addSubview:self.navigationBar];
            }
        }
        
        if ([keyPath isEqualToString:@"center"]) {
            
            CGPoint center = [new CGPointValue];
            
            if (center.y < -2.0) {
                center.y = -2.0;
                self.navigationBar.center = center;
                
                [UIView beginAnimations:@"DZNNavigationBarAnimation" context:nil];
                
                for (UIView *subview in self.navigationBar.subviews) {
                    if (subview != self.navigationBar.subviews[0]) {
                        subview.alpha = 0.0;
                    }
                }
                
                [UIView commitAnimations];
            }
        }
    }
    
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"loading"]) {
        [self updateToolbarItems];
    }
}


#pragma mark - View Auto-Rotation

#ifdef __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    if (self.hideBarsWithGestures) {
        [self.navigationBar removeObserver:self forKeyPath:@"hidden" context:&DZNWebViewControllerKVOContext];
        [self.navigationBar removeObserver:self forKeyPath:@"center" context:&DZNWebViewControllerKVOContext];
        [self.navigationBar removeObserver:self forKeyPath:@"alpha" context:&DZNWebViewControllerKVOContext];
    }
    [self.webView removeObserver:self forKeyPath:@"loading" context:&DZNWebViewControllerKVOContext];
    
    _backwardBarItem = nil;
    _forwardBarItem = nil;
    _stateBarItem = nil;
    _actionBarItem = nil;
    _progressView = nil;
    
    _backwardLongPress = nil;
    _forwardLongPress = nil;
    
    _webView.scrollView.delegate = nil;
    _webView.navDelegate = nil;
    _webView.UIDelegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;
    _URL = nil;
}

@end
