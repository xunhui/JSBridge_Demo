//
//  ExampleWKWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "Demo2WebViewController.h"
#import "WebViewJavascriptBridge.h"

#define PrekScheme @"prek"

@interface Demo2WKWebViewController ()

@property WebViewJavascriptBridge* bridge;
@property NSString* curInputText;
@property WKWebView* webview;

@end

@implementation Demo2WKWebViewController

- (void)viewWillAppear:(BOOL)animated {
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    _webview = webView;
    
    [self loadExamplePage:webView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(WKWebView*)webView {
//    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, 200, 30)];
    input.borderStyle = UITextBorderStyleRoundedRect;
    input.placeholder = @"请输入你想要执行的 JS 代码";
    input.font = [UIFont systemFontOfSize: 12];
    input.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [input addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:input];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendBtn setTitle:@"Native 向 Web 发送消息" forState:UIControlStateNormal];
    [sendBtn.layer setMasksToBounds: YES];
    [sendBtn.layer setCornerRadius: 5.0]; //设置矩形四个圆角
    [sendBtn.layer setBorderWidth: 1.0]; //边框宽度
    sendBtn.frame = CGRectMake(10, 290, 150, 30);
    sendBtn.titleLabel.font = [UIFont systemFontOfSize: 12];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sendBtn addTarget:self action:@selector(sendMsg2Web:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:sendBtn aboveSubview:webView];
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    NSLog(@"calllll: %@", data);
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)sendMsg2Web:(id)sender{
    // NSString *inputText = textFiled.text;
    NSLog(@"input text = %@", _curInputText);
    [_webview evaluateJavaScript:_curInputText completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"JS 执行结束的返回值 = %@", response);
    }];
}

- (void)textFieldEditChanged:(UITextField*)textField {
    _curInputText = textField.text;
//    NSLog(@"now text %@", _curInputText);
}


- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Web2Native" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (BOOL)isSchemeMatchPrek:(NSURL*)url {
    NSString* scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:PrekScheme];
}

// 打开相册
- (void)openCameraForWeb {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if (webView != _webView) { return; }
    NSURL *url = navigationAction.request.URL;
    NSLog(@"拦截到 Web 发出的请求 = %@", url);

    if ([self isSchemeMatchPrek:url]) {
        NSString* host = url.host.lowercaseString;
        if ([host isEqualToString: @"openphotoalbum"]) {
            [self openCameraForWeb];
            NSLog(@"打开相册");
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
