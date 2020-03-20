//
//  KMH5WebView.m
//  H5
//
//  Created by kmiMac on 2017/4/21.
//  Copyright © 2017年 Jasonh. All rights reserved.
//

#import "KMH5WebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Masonry/Masonry.h>


@protocol JSObjcCall <JSExport>
- (void)callChat:(NSString *)info;
- (void)callVideo:(NSString *)info;
- (void)backToNative;
- (void)getToken;
@end


@interface KMH5WebView()<UIWebViewDelegate,JSObjcCall>
@property (nonatomic,strong) NSURLRequest * request;

@property (nonatomic,strong) NSDictionary * dataDict;

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
    }
    return _activityIndicatorView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:frame];
        self.webView.delegate = self;
        [self addSubview:self.webView];
        
        if (CGRectEqualToRect(frame, CGRectZero)) {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        [self addSubview:self.activityIndicatorView];
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.activityIndicatorView startAnimating];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        }
        [self addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.activityIndicatorView];
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];

        [self.activityIndicatorView startAnimating];

    }
    return self;
}


-(void)setHiddenActivity:(BOOL)hiddenActivity{
    _hiddenActivity = hiddenActivity;
    if (_hiddenActivity) {
//        if ([self.activityIndicatorView isSubContentOf:self]) {
//            [self.activityIndicatorView removeFromSuperview];
//        }
        [self.activityIndicatorView removeFromSuperview];
    }else{
//        if (![self.activityIndicatorView isSubContentOf:self]) {
//            [self addSubview:self.activityIndicatorView];
//        }
        [self addSubview:self.activityIndicatorView];
    }
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
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [self.webView.scrollView.mj_header endRefreshing];
    
    [self.activityIndicatorView stopAnimating];

    
    NSLog(@"lod finsh");
    self.jsCallContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将tianbai对象指向自身
    self.jsCallContext[@"android"] = self;
    self.jsCallContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
//    self.jsBackContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //将tianbai对象指向自身
//    self.jsBackContext[@"robot"] = self;
//    self.jsBackContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
    
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


//-(void)callAndroidMethod{
//    NSLog(@"callAndroidMethod");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_delegate && [_delegate respondsToSelector:@selector(jsCallBack)]) {
//            [_delegate jsCallBack];
//        }
//    });
//}

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
        //    [newToken callWithArguments:@[loginInfoJSONStr]];
    }
    
    
    
    
//    NSString * result = [self.webView stringByEvaluatingJavaScriptFromString:loginInfoJSONStr];
//    NSLog(@"%@",result);
//    self.jsNativeContext
}


@end
