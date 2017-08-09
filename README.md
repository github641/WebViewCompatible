# WebViewCompatible
UIWebview、WKWebView、SafariViewcontroller的兼容与运用，
希望在iOS6-7使用UIWebView（TOWebViewController），在iOS8-iOS9使用WKWebView（DZNWebViewController），在iOS9+使用SafariViewController达成in-app browse的目的。
对这些API进行学习，对使用这些API的优秀开源项目进行学习。

为了兼容这两个项目，分别folk，并做了简化。这个项目将把以下两个项目合并到一起，并做兼容工作。
https://github.com/github641/DZNWebViewController
https://github.com/github641/TOWebViewController

在测试过程中，UIWebView，时不时会发生__cxa_throw的类似断电的中断。
疑似内存问题。
查到了，不要仅仅搜索__cxa_throw，而是搜『bc++abi.dylib`__cxa_throw:』


http://www.jianshu.com/p/c6a3d3c76635



