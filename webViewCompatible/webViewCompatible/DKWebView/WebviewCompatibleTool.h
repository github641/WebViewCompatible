//
//  WebviewCompatibleTool.h
//  webViewCompatible
//
//  Created by alldk on 2017/8/4.
//  Copyright © 2017年 alldk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebviewCompatibleTool : NSObject
+ (void)from:(UIViewController *)from toWebBrowserWithPush:(BOOL)isPush url:(NSString *)url;
@end
