//
//  KMH5WebView.m
//  H5
//
//  Created by kmiMac on 2017/4/21.
//  Copyright © 2017年 Jasonh. All rights reserved.
//

#import "KMH5WebView.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol JSObjcCall <JSExport>
- (void)callChat:(NSString *)info;
- (void)callVideo:(NSString *)info;
- (void)backToNative;
- (void)getToken;
@end


@interface KMH5WebView()<UIWebViewDelegate,JSObjcCall>
@property (nonatomic,strong) NSURLRequest * request;
@property (nonatomic, strong) JSContext *jsCallContext;
@property (nonatomic, strong) JSContext *jsNativeContext;
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicatorView;
@end



@implementation KMH5WebView

+ (instancetype)sharedInstance {
    static KMH5WebView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KMH5WebView alloc] init];
    });
    return instance;
}
-(UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_activityIndicatorView startAnimating];
        _activityIndicatorView.hidden = YES;
    }
    return _activityIndicatorView;
}
-(UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight= [UIScreen mainScreen].bounds.size.height;
        _webView.frame = CGRectMake(0, 0, screenWidth, screenHeight-statusHeight);
        if (@available(iOS 11.0,*)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.webView];
        [self addSubview:self.activityIndicatorView];
        self.activityIndicatorView.center = self.webView.center;
    }
    return self;
}



-(void)setHiddenActivity:(BOOL)hiddenActivity{
    _hiddenActivity = hiddenActivity;
    self.activityIndicatorView.hidden = _hiddenActivity;
}

-(void)setUrl:(NSURL *)url{
    _url = url;
    self.request = [NSURLRequest requestWithURL:url];
}
-(void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

-(void)startLoadRequest{
    if (self.request) {
        [self.webView loadRequest:self.request];
    }else{
//        NSLog(@"");
    }
}


#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.hiddenActivity  = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
        
    self.hiddenActivity = YES;

    
    NSLog(@"load finsh");
    self.jsCallContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将tianbai对象指向自身
    self.jsCallContext[@"android"] = self;
    self.jsCallContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    self.jsNativeContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将tianbai对象指向自身
    self.jsNativeContext[@"native"] = self;
    self.jsNativeContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

/**JS捕获进入图文咨询*/
-(void)callChat:(NSString *)info{
    NSLog(@"callChat");
    NSData * infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *inforDic = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableLeaves error:nil];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsCallChatWithParameterDictionary:)]) {
            [weakSelf.delegate jsCallChatWithParameterDictionary:inforDic];
        }
    });
}

- (void)callVideo:(NSString *)info{
    NSLog(@"callVideo");

    NSData * infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *inforDic = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableLeaves error:nil];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsCallAudioOrVideoWithParameterDictionary:)]) {
            [weakSelf.delegate jsCallAudioOrVideoWithParameterDictionary:inforDic];
        }
    });
}


-(void)backToNative{

    NSLog(@"backToNative");
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsCallBack)]) {
            [weakSelf.delegate jsCallBack];
        }
    });
}

-(void)getToken{
    NSLog(@"getToken");
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsRefreshLoginInfo)]) {
            [weakSelf.delegate jsRefreshLoginInfo];
        }
    });
}


-(void)refreshLoginInfoWithJSONString:(NSString *)loginInfoJSONStr{
    NSLog(@"objc->js newToken");
    JSValue * newToken = self.jsNativeContext[@"newToken"];
    if (newToken) {
        [self.jsNativeContext[@"native"] callWithArguments:@[loginInfoJSONStr]];
    }
}


@end
