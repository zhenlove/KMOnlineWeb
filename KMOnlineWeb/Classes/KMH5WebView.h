//
//  KMH5WebView.h
//  H5
//
//  Created by kmiMac on 2017/4/21.
//  Copyright © 2017年 Jasonh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMH5JSCallBackDelegate;

@interface KMH5WebView : UIView

@property (nonatomic,strong) NSString * urlString;
@property (nonatomic,strong) NSURL * url;
@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,assign) BOOL  hiddenActivity;
@property (nonatomic,weak) id<KMH5JSCallBackDelegate>  delegate;
+ (instancetype)sharedInstance;
-(void)startLoadRequest;
-(void)refreshLoginInfoWithJSONString:(NSString *)loginInfoJSONStr;
@end


@protocol KMH5JSCallBackDelegate <NSObject>

/**
 js回调图文咨询

 @param pDictionary 图文咨询参数
 
 pDictionary key ChanelId 频道号
 pDictionary key ConsultState 咨询状态
 pDictionary key DoctorName 医生名
 */
-(void)jsCallChatWithParameterDictionary:(NSDictionary *)pDictionary;

/**
 js回调音视频咨询

 @param pDictionary 音视频咨询参数
 
 pDictionary key CallType 咨询类型
 pDictionary key ChannelID 频道号
 pDictionary key UserID 医生ID
 pDictionary key UserFace 医生头像
 pDictionary key UserPhone 部门
 pDictionary key UserName 医生名
 pDictionary key UserInfo 医院
 */
-(void)jsCallAudioOrVideoWithParameterDictionary:(NSDictionary *)pDictionary;

/**
 js回调首页返回
 */
-(void)jsCallBack;

/**
 js回调刷新Token
 */
-(void)jsRefreshLoginInfo;
@end
