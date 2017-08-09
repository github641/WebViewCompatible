//
//  DKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef DK_weak
#if __has_feature(objc_arc_weak)
#define DK_weak weak
#else
#define DK_weak unsafe_unretained
#endif

extern const float DKInitialProgressValue;
extern const float DKInteractiveProgressValue;
extern const float DKFinalProgressValue;

typedef void (^DKWebViewProgressBlock)(float progress);
@protocol DKWebViewProgressDelegate;
@interface DKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, DK_weak) id<DKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, DK_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) DKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol DKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(DKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

