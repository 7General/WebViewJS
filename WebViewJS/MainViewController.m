//
//  MainViewController.m
//  WebViewJS
//
//  Created by 王会洲 on 16/8/15.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewJavascriptBridge.h"

@interface MainViewController()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;

@property WebViewJavascriptBridge* bridge;
@end

@implementation MainViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];

    NSString * path = [[NSBundle mainBundle] pathForResource:@"Content.html" ofType:nil];
    NSURLRequest * quest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [self.webView loadRequest:quest];

    /**开启日志*/
    [WebViewJavascriptBridge enableLogging];
    /**初始化-WebViewJavascriptBridge*/
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    [self makeButton];
    
    //********JS调用OC
    [self.bridge registerHandler:@"callViewLoad" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"前端发送的数据 %@", data);
        if (responseCallback) {
            // respons给前端的数据
            responseCallback(@{@"UName": @"洲洲哥的技术博客",@"URLS":@"http://www.jianshu.com/users/1338683b18e0/latest_articles"});
        }
    }];
    
    //*******OC调用JS
//    [self.bridge callHandler:@"UserLoginInfo" data:@{@"name": @"标哥"} responseCallback:^(id responseData) {
//        NSLog(@"from js: %@", responseData);
//    }];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

-(void)makeButton {
    UIButton *thisBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    thisBtn.frame = CGRectMake(100, 100, 140, 40);
    [thisBtn addTarget:self action:@selector(ocCallJS) forControlEvents:UIControlEventTouchUpInside];
    [thisBtn setTitle:@"点击oc调用js" forState:UIControlStateNormal];
    [self.view addSubview:thisBtn];
}

-(void)ocCallJS {
    // **********OC调用JS
   //[self.bridge callHandler:@"UserLogin" data:nil];
    
    [self.bridge callHandler:@"UserLoginInfo" data:@{@"name": @"标哥"} responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
    
    
   
}

@end
