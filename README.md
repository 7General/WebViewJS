
#### iOS和JS交互(含OC、html、js)代码


> 最近研究研究OC和JS互动的WebViewJavascriptBridge的用法

网上似乎有好多的关于OC和js互动的例子，但是没有一个完成的。今天我就把我的OC代码和Html代码统统的放出来。在说说网上的例子都是一个样没有一点区别，其实你关注洲洲哥的简书就够了。

今天以`WebViewJavascriptBridge`的`5.0.5`也就是最新的版本来示范。

跟着我的代码一块来
#### 1. 使用CocoaPods导入`WebViewJavascriptBridge`
这里我们使用最新版本
``` python
pod 'WebViewJavascriptBridge', '~> 5.0.5'
```
导入工程的shell命令这里我就不多说了。

#### 2. 编写OC代码（先写oc代码还是Js代码都可）
1. 引入头文件`#import "WebViewJavascriptBridge.h"`
2. 创建两个属性
  ```objc
  @property (nonatomic, strong) UIWebView * webView;

  @property WebViewJavascriptBridge* bridge;
  ```
3. 初始化`WebView`和`WebViewJavascriptBridge`
  ```paython
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    /**开启日志*/
    [WebViewJavascriptBridge enableLogging];
    /**初始化-WebViewJavascriptBridge*/
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
  ```
#### 3. `JS`调用`OC`代码
`NOTICE:`我们在写这里的调用代码之前，我们一定要知道`前端js函数`里一定要知道`函数名称`。这个很重要。
这里我们假设前端有个函数名称是`callViewLoad`他要调用OC的代码给返回来的数据最列表处理。

看看`OC的代码`如何处理`Js`发来的请求
```objc
[self.bridge registerHandler:@"callViewLoad" handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"前端发送的数据 %@", data);
    if (responseCallback) {
    // respons给前端的数据
    responseCallback(@{@"UName": @"洲洲哥的技术博客",@"URLS":@"http://www.jianshu.com/users/1338683b18e0/latest_articles"});
    }
    }];
```
来说说这里的`参数说明`
handler的回调中有`data`、`responseCallback`两个参数
1. 这其中的`data`是前端`js`函数给后端传送的数据：比如在登陆的时候，就要把账户信息和用户密码传入后端，给后端处理。这里的`data`就是存放着两个数据的
2. `responseCallback`是我们要给`前端js函数`返回的数据内容，前端给我们传入了用户名和密码，我们调用接口之后返回登陆结果给前端就是要用他了。但是以`字典形式`返回。

到这里我们的`JS调用OC`，`oc端的代码`已经说完了。

#### 前端`JS代码`的写法
1. `html`的代码写法
```html
<html>
    <head>
        <title>OC和JS互动Web</title>
        <script>
            /*这段代码是固定的，必须要放到js中*/
            function setupWebViewJavascriptBridge(callback) {
                if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
                if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
                window.WVJBCallbacks = [callback];
                var WVJBIframe = document.createElement('iframe');
                WVJBIframe.style.display = 'none';
                WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
                document.documentElement.appendChild(WVJBIframe);
                setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
            }
        
        /**与OC交互的所有JS方法都要放在此处注册，才能调用通过JS调用OC或者让OC调用这里的JS*/
        setupWebViewJavascriptBridge(function(bridge) {
             /**OC调用JS代码不含参数*/
             bridge.registerHandler('UserLogin', function() {
                                    alert('UserLogin')
             })
             /**OC调用JS代码含参数*/
             bridge.registerHandler('UserLoginInfo', function(data, responseCallback) {
                    responseCallback({'userId': '123456', 'Names': 'ZHOUZHOUGEDEBOKE'})
            })
                                     
             // **********************************JS调用OC
             bridge.callHandler('callViewLoad', {'blogURL': 'http://www.henishuo.com'}, function(responseCallback){
                                            alert(responseCallback.UName)
             })
        })
    </script>
    </head>
    <body>
        <button style = "background: yellow; height: 50px; width: 100px;">JS/OC互动</button>
    </body>
</html>
```
我们这里主要看html代码中的`callViewLoad`函数。这个就是他调用oc函数证明。这里的`callHandler`的里的参数可以看看
1. 第一个参数`callViewLoad` :函数名
2. {'blogURL': 'http://www.henishuo.com'}:表示给`OC代码传入的数据`
3. function(responseCallback) : 接受成功返回的`JS函数`这里可以在后端成功返回之后在这里我们可以监听到。和OC的Block类似。

这个函数的说明：JS给ObjC提供公开的API，ObjC端通过注册，就可以在JS端调用此API时，得到回调。ObjC端可以在处理完成后，反馈给JS，这样写就是在载入页面完成时就先调用。

`NOTICE:`这里只说了JS调用OC代码的声明。间间单单的介绍了一个方法的使用。但是我们也看到了再写前端JS函数的时候，有那么一大坨代码是必须要写的。不然是不会产生联合效果的。


## 更多消息
 更多信iOS开发信息 请以关注洲洲哥 的微信公众号，不定期有干货推送：
 
 ![这里写图片描述](http://upload-images.jianshu.io/upload_images/1416781-0f0cc08cfd424a54?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


