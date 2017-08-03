//
//  SysUIWebView.h
//  AboutUIWebView
//
//  Created by alldk on 2017/8/2.
//  Copyright © 2017年 alldk. All rights reserved.
// 过一遍头文件，配合文档搜索和 option + click对应的属性方法

//
//  UIWebView.h
//  UIKit
//
//  Copyright (c) 2007-2015 Apple Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

#import <UIKit/UIKitDefines.h>
/* lzy注170802：UIKitDefines.h的主要内容
 //
 //  UIKitDefines.h
 //  UIKit
 //
 //  Copyright (c) 2007-2016 Apple Inc. All rights reserved.
 //
 
 #import <Availability.h>
 
 #ifdef __cplusplus 倒底是什么意思？
 http://www.cnblogs.com/stonecrazyking/archive/2006/09/23/512552.html
 
 #ifdef __cplusplus
 #define UIKIT_EXTERN		extern "C" __attribute__((visibility ("default")))
 #else
 #define UIKIT_EXTERN	        extern __attribute__((visibility ("default")))
 #endif
 
 内联函数
 #define UIKIT_STATIC_INLINE	static inline
 
 UIKIT在各平台是否可用，可用的版本号
 #define UIKIT_AVAILABLE_IOS_ONLY(vers)      __IOS_AVAILABLE(vers) __WATCHOS_UNAVAILABLE __TVOS_UNAVAILABLE
 #define UIKIT_AVAILABLE_WATCHOS_ONLY(vers)  __IOS_UNAVAILABLE __WATCHOS_AVAILABLE(vers) __TVOS_UNAVAILABLE
 #define UIKIT_AVAILABLE_TVOS_ONLY(vers)     __IOS_UNAVAILABLE __WATCHOS_UNAVAILABLE __TVOS_AVAILABLE(vers)
 #define UIKIT_AVAILABLE_IOS_TVOS(_ios, _tvos) __IOS_AVAILABLE(_ios) __WATCHOS_UNAVAILABLE __TVOS_AVAILABLE(_tvos)
 #define UIKIT_AVAILABLE_IOS_WATCHOS_TVOS(_ios, _watchos, _tvos) __IOS_AVAILABLE(_ios) __WATCHOS_AVAILABLE(_watchos) __TVOS_AVAILABLE(_tvos)
 
 UIKIT的类CLASS在各平台是否可用，可用的版本号
 #define UIKIT_CLASS_AVAILABLE_IOS_ONLY(vers) UIKIT_EXTERN __IOS_AVAILABLE(vers) __WATCHOS_UNAVAILABLE __TVOS_UNAVAILABLE
 #define UIKIT_CLASS_AVAILABLE_WATCHOS_ONLY(vers) UIKIT_EXTERN __IOS_UNAVAILABLE __WATCHOS_AVAILABLE(vers) __TVOS_UNAVAILABLE
 #define UIKIT_CLASS_AVAILABLE_TVOS_ONLY(vers) UIKIT_EXTERN __IOS_UNAVAILABLE __WATCHOS_UNAVAILABLE __TVOS_AVAILABLE(vers)
 #define UIKIT_CLASS_AVAILABLE_IOS_TVOS(_ios, _tvos) UIKIT_EXTERN __IOS_AVAILABLE(_ios) __WATCHOS_UNAVAILABLE __TVOS_AVAILABLE(_tvos)
 #define UIKIT_CLASS_AVAILABLE_IOS_WATCHOS_TVOS(_ios, _watchos, _tvos) UIKIT_EXTERN __IOS_AVAILABLE(_ios) __WATCHOS_AVAILABLE(_watchos) __TVOS_AVAILABLE(_tvos)
 
 swift相关的处理
 #define UIKIT_DEFINE_AS_PROPERTIES (!defined(SWIFT_CLASS_EXTRA) || (defined(SWIFT_SDK_OVERLAY_UIKIT_EPOCH) && SWIFT_SDK_OVERLAY_UIKIT_EPOCH >= 1))
 #define UIKIT_REMOVE_ZERO_FROM_SWIFT (!defined(SWIFT_CLASS_EXTRA) || (defined(SWIFT_SDK_OVERLAY_UIKIT_EPOCH) && SWIFT_SDK_OVERLAY_UIKIT_EPOCH >= 1))
 #define UIKIT_STRING_ENUMS ((defined(SWIFT_SDK_OVERLAY_UIKIT_EPOCH) && SWIFT_SDK_OVERLAY_UIKIT_EPOCH >= 2))
 */

#import <UIKit/UIDataDetectors.h>
/* lzy注170802：
 //  UIDataDetectors.h
 //  UIKit
 //
 //  Copyright (c) 2009-2016 Apple Inc. All rights reserved.
 //
 
 #import <Foundation/Foundation.h>
 
 typedef NS_OPTIONS(NSUInteger, UIDataDetectorTypes) {
 UIDataDetectorTypePhoneNumber                                        = 1 << 0, // Phone number detection
 UIDataDetectorTypeLink                                               = 1 << 1, // URL detection
 UIDataDetectorTypeAddress NS_ENUM_AVAILABLE_IOS(4_0)                 = 1 << 2, // Street address detection
 UIDataDetectorTypeCalendarEvent NS_ENUM_AVAILABLE_IOS(4_0)           = 1 << 3, // Event detection
 UIDataDetectorTypeShipmentTrackingNumber NS_ENUM_AVAILABLE_IOS(10_0) = 1 << 4, // Shipment tracking number detection//???快递单号？？？
 UIDataDetectorTypeFlightNumber NS_ENUM_AVAILABLE_IOS(10_0)           = 1 << 5, // Flight number detection// 航班号
 UIDataDetectorTypeLookupSuggestion NS_ENUM_AVAILABLE_IOS(10_0)       = 1 << 6, // Information users may want to look up
 
 UIDataDetectorTypeNone          = 0,               // Disable detection
 UIDataDetectorTypeAll           = NSUIntegerMax    // Enable all types, including types that may be added later
 } __TVOS_PROHIBITED;

 */





#import <UIKit/UIScrollView.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UIWebViewNavigationType) {// wv导航类型
    UIWebViewNavigationTypeLinkClicked,//点击了链接
    UIWebViewNavigationTypeFormSubmitted,// 表单提交
    UIWebViewNavigationTypeBackForward,// 返回
    UIWebViewNavigationTypeReload,// 重载
    UIWebViewNavigationTypeFormResubmitted,// 重新提交表单
    UIWebViewNavigationTypeOther// 其他
} __TVOS_PROHIBITED;// TVOS禁止使用

typedef NS_ENUM(NSInteger, UIWebPaginationMode) {// 标记页数的方式
    UIWebPaginationModeUnpaginated,// 不标记页数
    UIWebPaginationModeLeftToRight,
    UIWebPaginationModeTopToBottom,
    UIWebPaginationModeBottomToTop,
    UIWebPaginationModeRightToLeft
} __TVOS_PROHIBITED;

typedef NS_ENUM(NSInteger, UIWebPaginationBreakingMode) {// 分页方式
    UIWebPaginationBreakingModePage,
    UIWebPaginationBreakingModeColumn
} __TVOS_PROHIBITED;

/* lzy注170802：
 UIWebView的class-dump出的头文件
 https://github.com/AlexMcArdle/iOS10-Runtime-Headers/blob/d544ab20db6307cab501cf5d396f46a8023469c3/Frameworks/UIKit.framework/UIWebView.h
 UIWebViewInternal的头文件
 https://github.com/AlexMcArdle/iOS10-Runtime-Headers/blob/d544ab20db6307cab501cf5d396f46a8023469c3/Frameworks/UIKit.framework/UIWebViewInternal.h
 Generated by RuntimeBrowser
 Image: /System/Library/Frameworks/UIKit.framework/UIKit


@interface UIWebViewInternal : NSObject {
    UIWebBrowserView * browserView;
    UICheckeredPatternView * checkeredPatternView;
    long long  clickedAlertButtonIndex;
    <UIWebViewDelegate> * delegate;
    unsigned int  didRotateEnclosingScrollView;
    unsigned int  drawInWebThread;
    unsigned int  drawsCheckeredPattern;
    unsigned int  hasOverriddenOrientationChangeEventHandling;
    unsigned int  inRotation;
    unsigned int  isLoading;
    UIWebPDFViewHandler * pdfHandler;
    NSURLRequest * request;
    unsigned int  scalesPageToFit;
    UIScrollView * scroller;
    unsigned int  webSelectionEnabled;
    UIWebViewWebViewDelegate * webViewDelegate;
}

 */
@class UIWebViewInternal;// 苹果私有类
@protocol UIWebViewDelegate;// 声明代理

NS_CLASS_AVAILABLE_IOS(2_0) __TVOS_PROHIBITED

@interface UIWebView : UIView <NSCoding, UIScrollViewDelegate>

@property (nullable, nonatomic, assign) id <UIWebViewDelegate> delegate;


/**
 和wv关联着的scroll view。开发者可以访问这个scroll view，在你想要 自定义web view的滚动行为的时候。
 */
@property (nonatomic, readonly, strong) UIScrollView *scrollView NS_AVAILABLE_IOS(5_0);// 有sv的属性

/* lzy注170802：
 三个实例方法，加载数据
 */

/**
 Connects to a given URL by initiating an asynchronous client request.
 Don’t use this method to load local HTML files; instead, use loadHTMLString:baseURL:. To stop this load, use the stopLoading method. To see whether the receiver is done loading the content, use the loading property.
 通过给定的URL初始化一个异步的客户端请求，链接这个请求。
 不要使用这个方法加载本地的HTML文件，而去使用loadHTMLString:baseURL:方法。
 停止加载：使用stopLoading方法；
 是否加载完毕：使用 loading属性查看。
 */
- (void)loadRequest:(NSURLRequest *)request;

/**
 Sets the main page content and base URL.
 To help you avoid being vulnerable to security attacks, be sure to use this method to load local HTML files; don’t use loadRequest:.
string：主页地址
 baseURL:内容所在的url
 为了防止开发者成为易受到『安全攻击』的对象，务必用于加载背地文件而不是网络资源。
 */
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;

@property (nullable, nonatomic, readonly, strong) NSURLRequest *request;

///重载
- (void)reload;


/**停止加载
 Stops the loading of any web content managed by the receiver.
 Stops any content in the process of being loaded by the main frame or any of its children frames. Does nothing if no content is being loaded.
 */
- (void)stopLoading;
///返回
- (void)goBack;
///下一页
- (void)goForward;

@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;// 当前页是否可以前往前一页
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;// 当前页是否可以前往下一页
@property (nonatomic, readonly, getter=isLoading) BOOL loading;// 是否是加载状态

/* lzy注170802：
 Returns the result of running a JavaScript script. Although this method is not deprecated, best practice is to use the evaluateJavaScript:completionHandler: method of the WKWebView class instead.
 New apps should instead use the evaluateJavaScript:completionHandler: method from the WKWebView class. Legacy apps should adopt that method if possible.
 Important
 The stringByEvaluatingJavaScriptFromString: method waits synchronously for JavaScript evaluation to complete. If you load web content whose JavaScript code you have not vetted（审查）, invoking this method could hang your app. Best practice is to adopt the WKWebView class and use its evaluateJavaScript:completionHandler: method instead.
 */
- (nullable NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;// 执行js代码

/**
 A Boolean value determining whether the webpage scales to fit the view and the user can change the scale.
 If YES, the webpage is scaled to fit and the user can zoom in and zoom out. If NO, user zooming is disabled. The default value is NO.
 */
@property (nonatomic) BOOL scalesPageToFit;// 是否自动缩放页面

@property (nonatomic) BOOL detectsPhoneNumbers NS_DEPRECATED_IOS(2_0, 3_0);// 检测『电话号码』3.0就弃用了。需要使用UIDataDetectorTypes

/**
 The types of data converted to tappable URLs in the text view.
 You can use this property to specify the types of data (phone numbers, http links, and so on) that should be automatically converted to URLs in the text view. When tapped, the text view opens the application responsible for handling the URL type and passes it the URL. 
 Note that data detection does not occur if the text view's editable property is set to YES.
 当text view的可编辑属性为YES的时候，data detection是不会起作用的。
 */
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes NS_AVAILABLE_IOS(3_0);// 检测的数据类型


/**
 A Boolean value that determines whether HTML5 videos play inline or use the native full-screen controller.
 You must set this property to play inline video. Set this property to true to play videos inline. Set this property to false to use the native full-screen controller.
 
 When adding a video element to a HTML document on the iPhone, you must also include the playsinline attribute.
 The default value for iPhone is false and the default value for iPad is true.
 Important
 Apps created before iOS 10.0 must use the webkit-playsinline attribute.
 */
@property (nonatomic) BOOL allowsInlineMediaPlayback NS_AVAILABLE_IOS(4_0); // iPhone Safari defaults to NO. iPad Safari defaults to YES。

/**
 A Boolean value that determines whether HTML5 videos can play automatically or require the user to start playing them.
 The default value on both iPad and iPhone is YES. To make media play automatically when loaded, set this property to NO and ensure the <audio> or <video> element you want to play has the autoplay attribute set.
 */
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction NS_AVAILABLE_IOS(4_0); // iPhone and iPad Safari both default to YES

@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay NS_AVAILABLE_IOS(5_0); // iPhone and iPad Safari both default to YES

/**
 A Boolean value indicating（表明） whether the web view suppresses（抑制） content rendering until it is fully loaded into memory.
 When set to YES, the web view does not attempt to render incoming（到来的、要来的） content as it arrives. Instead, the view’s current contents remain in place until all of the new content has been received, at which point the new content is rendered. 
 
 This property does not affect the rendering of content retrieved（恢复、找回） after a frame finishes loading.
 The value of this property is NO by default.
 */
@property (nonatomic) BOOL suppressesIncrementalRendering NS_AVAILABLE_IOS(6_0); // iPhone and iPad Safari both default to NO

/**
 A Boolean value indicating whether web content can programmatically display the keyboard.
 When this property is set to YES, the user must explicitly（明确地） tap the elements in the web view to display the keyboard (or other relevant input view) for that element. 
 When set to NO, a focus event on an element causes the input view to be displayed and associated with that element automatically.
 The default value for this property is YES.
 */
@property (nonatomic) BOOL keyboardDisplayRequiresUserAction NS_AVAILABLE_IOS(6_0); // default is YES

/**
 The layout of content in the web view.
 This property determines whether content in the web view is broken up into pages that fill the view one screen at a time, or shown as one long scrolling view. 
 If set to a paginated form, this property toggles a paginated layout on the content, causing the web view to use the values of pageLength and gapBetweenPages to relayout its content.
 See UIWebPaginationMode for possible values. The default value is UIWebPaginationModeUnpaginated.
 */
@property (nonatomic) UIWebPaginationMode paginationMode NS_AVAILABLE_IOS(7_0);

/**
 The manner in which column- or page-breaking occurs.
 This property determines whether certain CSS properties regarding column- and page-breaking are honored or ignored. 
 When this property is set to UIWebPaginationBreakingModeColumn, the content respects the CSS properties related to column-breaking in place of page-breaking.
 See UIWebPaginationBreakingMode for possible values. The default value is UIWebPaginationBreakingModePage.
 */
@property (nonatomic) UIWebPaginationBreakingMode paginationBreakingMode NS_AVAILABLE_IOS(7_0);

/**
 The size of each page, in points, in the direction that the pages flow.
 When paginationMode is right to left or left to right, this property represents the width of each page. When paginationMode is top to bottom or bottom to top, this property represents the height of each page.
 The default value is 0, which means the layout uses the size of the viewport to determine the dimensions of the page. Adjusting the value of this property causes a relayout.
 */
@property (nonatomic) CGFloat pageLength NS_AVAILABLE_IOS(7_0);
@property (nonatomic) CGFloat gapBetweenPages NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) NSUInteger pageCount NS_AVAILABLE_IOS(7_0);

@property (nonatomic) BOOL allowsPictureInPictureMediaPlayback NS_AVAILABLE_IOS(9_0);

/**
 Description
 A Boolean value that determines whether pressing on a link displays a preview of the destination for the link.
 This property is available on devices that support 3D Touch. Default value is NO.
 If you set this value to YES for a web view, users (with devices that support 3D Touch) can preview link destinations, and can preview detected data such as addresses, by pressing on links. Such previews are known to users as peeks. If a user presses deeper, the preview navigates (or pops, in user terminology（术语）) to the destination. Because pop navigation switches the user from your app to Safari, it is opt-in, by way of this property, rather default behavior for this class.
 If you want to support link preview but also want to keep users within your app, you can switch from using the UIWebView class to the SFSafariViewController class. If you are using a web view as an in-app browser, making this change is best practice. The Safari view controller class automatically supports link previews.
 */
@property (nonatomic) BOOL allowsLinkPreview NS_AVAILABLE_IOS(9_0); // default is NO
@end

__TVOS_PROHIBITED @protocol UIWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END

