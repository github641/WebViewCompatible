//
//  Macro.h
//  webViewCompatible
//
//  Created by alldk on 2017/8/4.
//  Copyright © 2017年 alldk. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
/* lzy注170804：
 如果 编译选项设置中，部署版本不符合，无法通过编译
 
 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED != 20000 && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
#error DZNWebView doesn't support Deployment Target version < 7.0
#else
#define DZNOK

#endif


#endif /* Macro_h */
