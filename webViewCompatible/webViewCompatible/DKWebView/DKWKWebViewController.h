//
//  DKWKWebViewController.h
//  DKWKWebViewController
//  https://github.com/dzenbot/DKWKWebViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/25/13.
//  Copyright (c) 2014 DK Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>



/**
 Types of supported navigation tools.
 */
typedef NS_OPTIONS(NSUInteger, DKWKWebNavigationTools) {
    DKWKWebNavigationToolAll = -1,
    DKWKWebNavigationToolNone = 0,
    DKWKWebNavigationToolBackward = (1 << 0),
    DKWKWebNavigationToolForward = (1 << 1),
    DKWKWebNavigationToolStopReload = (1 << 2),
};

/**
 Types of supported actions (i.e. Share & Copy link, Add to Reading List, Open in Safari/Chrome/Opera/Dolphin).
 */
typedef NS_OPTIONS(NSUInteger, DKsupportedWebActions) {
    DKWKWebActionAll = -1,
    DKWKWebActionNone = 0,
    DKsupportedWebActionshareLink = (1 << 0),
    DKWKWebActionCopyLink = (1 << 1),
    DKWKWebActionReadLater = (1 << 2),
    DKWKWebActionOpenSafari = (1 << 3),
};

/**
 Types of information to be shown on navigation bar. Default is DKWKWebNavigationPromptAll.
 */
typedef NS_OPTIONS(NSUInteger, DKWKWebNavigationPrompt) {
    DKWKWebNavigationPromptNone = 0,
    DKWKWebNavigationPromptTitle = (1 << 0),
    DKWKWebNavigationPromptURL = (1 << 1),
    DKWKWebNavigationPromptAll = DKWKWebNavigationPromptTitle | DKWKWebNavigationPromptURL,
};


@protocol DKNavigationDelegate;

@interface DKWKWebView : WKWebView

@property (nonatomic, weak) id <DKNavigationDelegate> navDelegate;

@end


@protocol DKNavigationDelegate <WKNavigationDelegate>

- (void)webView:(DKWKWebView *)webView didUpdateProgress:(CGFloat)progress;

@end



/**
 A very simple web browser with useful navigation and tooling features.
 */
@interface DKWKWebViewController : UIViewController <DKNavigationDelegate, WKUIDelegate, UITableViewDataSource, UITableViewDelegate>

/* lzy注170805：
 把TO的『done』按钮的移植过来
 */
/**
 Shows the Done button when presented modally. When tapped, it dismisses the view controller.
 
 Default value is YES.
 */
@property (nonatomic,assign)    BOOL showDoneButton;

/**
 If desired, override the title of the system 'Done' button to this string.
 
 Default value is nil.
 */
@property (nonatomic,copy)    NSString *doneButtonTitle;



/** The web view that the controller manages. */
@property (nonatomic, strong) DKWKWebView *webView;
/** The URL identifying the location of the content to load. */
@property (nonatomic, readwrite) NSURL *URL;
/** The supported navigation tool bar items. Default is All. */
@property (nonatomic, readwrite) DKWKWebNavigationTools supportedWebNavigationTools;
/** The supported actions like sharing and copy link, add to reading list, open in Safari, etc. Default is All. */
@property (nonatomic, readwrite) DKsupportedWebActions supportedWebActions;
/** The information to be shown on navigation bar. Default is DKWKWebNavigationPromptAll. */
@property (nonatomic, readwrite) DKWKWebNavigationPrompt webNavigationPrompt;
/** Yes if a progress bar indicates the . Default is YES. */
@property (nonatomic) BOOL showLoadingProgress;
/** YES if long pressing the backward and forward buttons the navigation history is displayed. Default is YES. */
@property (nonatomic) BOOL allowHistory;
/** YES if both, the navigation and tool bars should hide when panning vertically. Default is YES. */
@property (nonatomic) BOOL hideBarsWithGestures;
/** [Deprecated] YES if should set the title automatically based on the page title and URL. Default is YES. */
@property (nonatomic) BOOL showPageTitleAndURL __deprecated_msg("Use 'webNavigationPrompt' instead.");

///------------------------------------------------
/// @name Initialization
///------------------------------------------------

/**
 Initializes and returns a newly created webview controller with an initial HTTP URL to be requested as soon as the view appears.
 
 @param URL The HTTP URL to be requested.
 @returns The initialized webview controller.
 */
- (instancetype)initWithURL:(NSURL *)URL tab:(BOOL)tab;

/**
 Initializes and returns a newly created webview controller for local HTML navigation.
 
 @param URL The file URL of the main html.
 @returns The initialized webview controller.
 */
- (instancetype)initWithFileURL:(NSURL *)URL;

/**
 Starts loading a new request. Useful to programatically update the web content.
 
 @param URL The HTTP or file URL to be requested.
 */
- (void)loadURL:(NSURL *)URL NS_REQUIRES_SUPER;

/**
 Starts loading a new request. Useful to programatically update the web content.

 @param URL The HTTP or file URL to be requested.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 */
- (void)loadURL:(NSURL *)URL baseURL:(NSURL *)baseURL;

///------------------------------------------------
/// @name Appearance customisation
///------------------------------------------------

// The back button displayed on the tool bar (requieres DKWKWebNavigationToolBackward)
@property (nonatomic, strong) UIImage *backwardButtonImage;
// The forward button displayed on the tool bar (requieres DKWKWebNavigationToolForward)
@property (nonatomic, strong) UIImage *forwardButtonImage;
// The stop button displayed on the tool bar (requieres DKWKWebNavigationToolStopReload)
@property (nonatomic, strong) UIImage *stopButtonImage;
// The reload button displayed on the tool bar (requieres DKWKWebNavigationToolStopReload)
@property (nonatomic, strong) UIImage *reloadButtonImage;
// The action button displayed on the navigation bar (requieres at least 1 DKsupportedWebActions value)
@property (nonatomic, strong) UIImage *actionButtonImage;


///------------------------------------------------
/// @name Delegate Methods Requiring Super
///------------------------------------------------

// DKNavigationDelegate
- (void)webView:(DKWKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;
- (void)webView:(DKWKWebView *)webView didCommitNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;
- (void)webView:(DKWKWebView *)webView didUpdateProgress:(CGFloat)progress NS_REQUIRES_SUPER;
- (void)webView:(DKWKWebView *)webView didFinishNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;
- (void)webView:(DKWKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error NS_REQUIRES_SUPER;

// WKUIDelegate
- (DKWKWebView *)webView:(DKWKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures NS_REQUIRES_SUPER;

// UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView NS_REQUIRES_SUPER;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section NS_REQUIRES_SUPER;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

@end
