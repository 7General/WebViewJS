//
//  MainViewController.m
//  WebViewJS
//
//  Created by 王会洲 on 16/8/15.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()
@property (nonatomic, strong) UIWebView * webView;
@end

@implementation MainViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 300, 400)];
    [self.view addSubview:self.webView];
    
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"ContentHTML.HTML" ofType:nil];
    NSURLRequest * quest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [self.webView loadRequest:quest];

}

- (void)call{    //拨打电话
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"tel://10086"]];
}
//是否允许加载从webview获得的请求/*
//*该方法可以实现js调用OC
//*js和OC交互的第三框架可以使用：WebViewJavaScriptBridge
//*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //获得html点击的链接
    NSString *url = request.URL.absoluteString;    //设置协议头
    NSString *scheme = @"zc://";    //判断获得的链接前面是否包含设置头
    if([url hasPrefix:scheme]){        //切割字符串
        NSString *methodName =
        [url substringFromIndex:scheme.length];
        //调用打电话的方法
        
        [self performSelector:NSSelectorFromString(methodName) withObject:nil];
        return NO;
    }else{
        return YES;
    }
}


@end
