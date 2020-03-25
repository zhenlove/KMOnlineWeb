//
//  KMWebViewController.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/17.
//  Copyright © 2020 zhenlove. All rights reserved.
//

#import "KMWebViewController.h"
#import "KMH5WebView.h"
#import <ImSDK/ImSDK.h>
#import <KMTIMSDK/KMTIMSDK.h>
@import KMNetwork;
@import KMAgoraRtc;


typedef NS_ENUM(NSInteger, KMRoomState) {
    KMRoomState_Invalid = -1,//状态无效
    KMRoomState_NoVisit = 0,//未就诊
    KMRoomState_Waiting = 1,//候诊中
    KMRoomState_Consulting = 2,//就诊中
    KMRoomState_Consulted = 3,//已就诊
    KMRoomState_Calling = 4,//呼叫中
    KMRoomState_Leaving = 5,//离开中
    KMRoomState_PatientsLeaving = 6//患者离开
};

@interface KMWebViewController ()
<KMH5JSCallBackDelegate,
KMFloatViewManagerDelegate,
KMRoomStateListenerDelegate,
KMCallingSystemOperationDelegate,
KMCallInfoModel,
KMChatControllerDelegate,
UINavigationControllerDelegate>
@property (nonatomic,strong) KMH5WebView * h5WebView;
@property (nonatomic,strong) KMIMConfigModel * imConfigModel;
@property (nonatomic,strong) KMMediaConfigModel * mediaConfigModel;
@property (nonatomic,assign) BOOL isRequesting;
@end

@implementation KMWebViewController
-(KMH5WebView *)h5WebView{
    if (!_h5WebView) {
        _h5WebView = [KMH5WebView sharedInstance];
        _h5WebView.webView.backgroundColor  =  [UIColor whiteColor];
        _h5WebView.delegate = self;
    }
    return _h5WebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [KMFloatViewManager sharedInstance].delegate = self;
    self.navigationController.delegate = self;
    [self.view addSubview:self.h5WebView];
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight= [UIScreen mainScreen].bounds.size.height;
    self.h5WebView.frame = CGRectMake(0, statusHeight, screenWidth, screenHeight-statusHeight);

    self.h5WebView.urlString = self.urlString;
    [self.h5WebView startLoadRequest];
    [self performSelector:@selector(requestIMConfig) withObject:nil afterDelay:0.1];
    // Do any additional setup after loading the view.
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:[viewController isKindOfClass:[self class]] animated:true];
}

-(void)dealloc{
    NSLog(@"KMWebViewController 释放了");
}


#pragma mark -
#pragma mark -KMNetWork

// 获取IM配置
-(void)requestIMConfig {
    __weak typeof(self)weakSelf = self;
    NSString * url = [[KMServiceModel sharedInstance].baseURL stringByAppendingString:@"/IM/Config"];

    [KMNetwork requestWithUrl:url
                       method:@"GET"
                   parameters:nil
                   isHttpBody:false
                     callBack:^(NSDictionary<NSString *,id> * _Nullable result, NSError * _Nullable error) {
        if (result) {
            weakSelf.imConfigModel = [[KMIMConfigModel alloc]initWithDictionary:result[@"Data"]];//[KMIMConfigModel mj_objectWithKeyValues:result[@"Data"]];
            [weakSelf logInIM];
        }
        if (error) {
            NSLog(@"获取IM配置失败");
        }
    }];
}
// 登录IM
-(void)logInIM {
    [[KMTIMManager sharedInstance] setupWithAppId:self.imConfigModel.sdkAppID.integerValue
                                          UserSig:self.imConfigModel.userSig
                                    andIdentifier:self.imConfigModel.identifier];
    [KMTIMManager sharedInstance].delegate = self;
    [[KMTIMManager sharedInstance] loginOfSucc:^{
        NSLog(@"IM登录成功");
        NSDictionary *dic = @{TIMProfileTypeKey_Nick:self.userInfoModel.UserCNName,TIMProfileTypeKey_FaceUrl:self.userInfoModel.PhotoUrl};
        [[TIMFriendshipManager sharedInstance] modifySelfProfile:dic succ:^{
            NSLog(@"设置用户资料成功");
        } fail:^(int code, NSString *msg) {
            NSLog(@"设置用户资料 code:%d msg:%@",code,msg);
        }];
    } fail:^(int code, NSString * _Nonnull msg) {
        NSLog(@"IM登录失败 code:%d msg:%@",code,msg);
    }];
}

// 获取媒体配置
-(void)getMediaConfigWithChannelID:(NSString *)channelID {
    __weak typeof(self)weakSelf = self;
    NSString * url = [[KMServiceModel sharedInstance].baseURL stringByAppendingString:@"/IM/MediaConfig"];
    NSDictionary *paramsDict = @{@"ChannelID":[NSNumber numberWithInteger:channelID.integerValue],@"Identifier":self.imConfigModel.identifier};

    [KMNetwork requestWithUrl:url
                       method:@"GET"
                   parameters:paramsDict
                   isHttpBody:false
                     callBack:^(NSDictionary<NSString *,id> * _Nullable result, NSError * _Nullable error) {
        weakSelf.isRequesting = NO;
        if (result) {
            weakSelf.mediaConfigModel = [[KMMediaConfigModel alloc]initWithDictionary:result[@"Data"]];//[KMMediaConfigModel mj_objectWithKeyValues:result[@"Data"]];
            //进入诊室
            [weakSelf updateChatRoomChannelID:weakSelf.mediaConfigModel.ILiveConfig.ChannelID state:KMRoomState_Waiting];
        }
        if (error) {
            NSLog(@"获取媒体配置失败");
        }
    }];
}
// 设置房间状态
-(void)updateChatRoomChannelID:(NSString *)channelID state:(KMRoomState)state {
    NSString * url = [[KMServiceModel sharedInstance].baseURL stringByAppendingString:@"/IM/Room/State"];
    NSDictionary *paramsDict = @{@"ChannelID":[NSNumber numberWithInteger:channelID.integerValue],@"State":@(state)};
    [KMNetwork requestWithUrl:url
                       method:@"PUT"
                   parameters:paramsDict
                   isHttpBody:false
                     callBack:^(NSDictionary<NSString *,id> * _Nullable result, NSError * _Nullable error) {
        if (result) {
            NSLog(@"设置房间状态--成功");
        }
        if (error) {
            NSLog(@"设置房间状态--失败");
        }
    }];
}

#pragma mark -
#pragma mark -KMRoomStateListenerDelegate

- (void)listenerToChannelID:(NSString *)channelID withCustomElem:(NSDictionary *)customElem {
    if ([self.mediaConfigModel.ILiveConfig.ChannelID isEqualToString:channelID]) {
        if ([customElem[@"State"] integerValue] == KMRoomState_Calling) {
            KMCallingSystemController * callingSystem =[[KMCallingSystemController alloc]init];
            callingSystem.modalPresentationStyle = UIModalPresentationFullScreen;
            callingSystem.delegate = self;
            callingSystem.userDelegate = self;
            [self presentViewController:callingSystem animated:true completion:nil];
        }
    }
}

#pragma mark -
#pragma mark -KMFloatViewManagerDelegate
- (void)clickedHangupButton{
    NSLog(@"挂断");
    [self showTipInquiry];
}
- (void)clickedPrescribeButton{
    NSLog(@"开处方");
}

#pragma mark -
#pragma mark -KMH5JSCallBackDelegate

/**
 js回调图文咨询
 */
-(void)jsCallChatWithParameterDictionary:(NSDictionary *)pDictionary{
    NSString * ChanelId = [[pDictionary objectForKey:@"ChanelId"] stringValue];
    NSInteger  ConsultState = [[pDictionary objectForKey:@"ConsultState"] integerValue];
//    NSString * DoctorName = [pDictionary objectForKey:@"DoctorName"];
        
    KMChatController  * chatController = [[KMChatController alloc]init];
    chatController.convId = ChanelId;
    chatController.title = @"图文问诊";
    chatController.delegate = self;
    chatController.consulationState = ConsultState;
    [self.navigationController pushViewController:chatController animated:true];
    
}

/**
 js回调音视频咨询
 */
-(void)jsCallAudioOrVideoWithParameterDictionary:(NSDictionary *)pDictionary{

    NSString * ChanelId = [[pDictionary objectForKey:@"ChannelID"] stringValue];
    _callName = pDictionary[@"UserName"];
    _callImage = pDictionary[@"UserFace"];
    if (!self.isRequesting) {
        self.isRequesting = YES;
        [self getMediaConfigWithChannelID:ChanelId];
    }
}



/**
 js回调首页返回
 */
-(void)jsCallBack{
    [self.navigationController popViewControllerAnimated:true];
}

/**
 js回调刷新Token
 */
-(void)jsRefreshLoginInfo{
    NSMutableDictionary * loginInfo = [NSMutableDictionary dictionary];
    [loginInfo setObject:[KMServiceModel sharedInstance].appKey forKey:@"AppKey"];
    [loginInfo setObject:[KMServiceModel sharedInstance].apptoken forKey:@"AppToken"];
    [loginInfo setObject:[KMServiceModel sharedInstance].usertoken forKey:@"UserToken"];
    [loginInfo setObject:[KMServiceModel sharedInstance].orgId forKey:@"OrgId"];
    [loginInfo setObject:@"ios" forKey:@"Platform"];
    NSString * loginInfoJSONStr = [self dictionaryToJson:loginInfo];
    [self.h5WebView refreshLoginInfoWithJSONString:loginInfoJSONStr];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark -
#pragma mark -KMCallingSystemOperationDelegate
-(void)answerCallingInKMCallingOperation {
    //设置接听
    [self updateChatRoomChannelID:self.mediaConfigModel.ILiveConfig.ChannelID state:KMRoomState_Consulting];
    //进入图文
    KMChatController  * chatController = [[KMChatController alloc]init];
    chatController.convId = self.mediaConfigModel.ILiveConfig.ChannelID;
    chatController.delegate = self;
    chatController.title = @"视频问诊";
    [self.navigationController pushViewController:chatController animated:true];
    //进入视频
    NSNumber *userId = [NSNumber numberWithInteger:self.mediaConfigModel.ILiveConfig.Identifier.integerValue];
    [[KMFloatViewManager sharedInstance] showViewWithChannelKey:self.mediaConfigModel.MediaChannelKey
                                                      channelId:self.mediaConfigModel.ILiveConfig.ChannelID
                                                         userId:userId.unsignedIntegerValue
                                                          appId:self.mediaConfigModel.AppID
                                                       userType:1];
}
-(void)rejectedCallingInKMCallingOperation {
    //设置挂断
    [self updateChatRoomChannelID:self.mediaConfigModel.ILiveConfig.ChannelID state:KMRoomState_Waiting];
}
#pragma mark -
#pragma mark -KMChatControllerDelegate
/// 点击患者咨询
-(void)clickePatientInfo:(NSDictionary *)patientInfoDic{
    KMPatientInfoVC * infoVC  = [[KMPatientInfoVC alloc] init];
    infoVC.userInfoDic = patientInfoDic;
    [self.navigationController pushViewController:infoVC animated:YES];
}

/// 点击处方
-(void)clickePrescribe:(NSString *)prescribeUrl oPDRegisterID:(NSString *)OPDRegisterID{
    KMIMWebViewController *webView = [[KMIMWebViewController alloc]init];
    webView.prescribeUrl = prescribeUrl;
    [self.navigationController pushViewController:webView animated:YES];
}

/// 点击返回
- (BOOL)clickeBackBtnController {
    if ([KMFloatViewManager sharedInstance].isShow) {
        [self showTipInquiry];
        return NO;
    }else{
        return YES;
    }
}
/// 退出本次问诊
-(void)showTipInquiry {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                             message:@"确定要退出本次问诊？"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf updateChatRoomChannelID:self.mediaConfigModel.ILiveConfig.ChannelID state:KMRoomState_NoVisit];
        [[KMFloatViewManager sharedInstance] dissView];
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}
@end
