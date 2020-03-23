//
//  KMOnlineManager.m
//  KMOnlineWeb
//
//  Created by Ed on 2020/3/19.
//

#import "KMOnlineManager.h"
#import "KMModels.h"
#import "KMWebViewController.h"
@import KMNetwork;

@interface KMOnlineManager()
@property (nonatomic,strong) KMUserInfoModel * userInfoModel;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,weak) UIViewController * fromVC;
@property (nonatomic,assign) BOOL isRequesting;
@end

@implementation KMOnlineManager
+ (instancetype)sharedInstance
{
    static KMOnlineManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KMOnlineManager alloc] init];
    });
    return instance;
}
- (void)reloadWebViewWithUrl:(NSString *)url withDic:(NSDictionary *)dic showViewController:(UIViewController *)vc {
    self.baseUrl = url;
    self.fromVC = vc;
    if (!self.isRequesting) {
        self.isRequesting = YES;
        [self performSelector:@selector(loginOnlineWithParam:) withObject:dic afterDelay:0];
    }
}

- (void)loginOnlineWithParam:(NSDictionary *)dic {
    __weak typeof(self)weakSelf = self;
    NSString * urls = [[KMServiceModel sharedInstance].baseURL stringByAppendingString:@"/users/InterLoginNoAccount"];
//    [KMNetwork requestWithUrl:urls method:@"POST" parameters:dic isHttpBody:false callback:^(NSDictionary<NSString *,id> * _Nullable result, NSError * _Nullable error) {
//
//    }];
    [KMNetwork requestWithUrl:urls
                       method:@"POST"
                   parameters:dic
                   isHttpBody:false
                     callBack:^(NSDictionary* _Nullable result, NSError * _Nullable error) {
        if (result) {
            weakSelf.isRequesting = NO;
            weakSelf.userInfoModel = [[KMUserInfoModel alloc]initWithDictionary:result[@"Data"]];
            [KMServiceModel sharedInstance].usertoken = weakSelf.userInfoModel.UserToken;
            [weakSelf showViewController];
        }
        if (error) {
            NSLog(@"登录失败");
            weakSelf.isRequesting = NO;
        }
    }];
}

- (void)showViewController {
    NSDictionary *dics = @{@"AppKey":[KMServiceModel sharedInstance].appKey,
                           @"AppToken":[KMServiceModel sharedInstance].apptoken,
                           @"UserToken":[KMServiceModel sharedInstance].usertoken,
                           @"OrgId":[KMServiceModel sharedInstance].orgId};
    NSString * urlString = [NSString stringWithFormat:@"%@?%@",self.baseUrl,[self spliceStringFromDictionary:dics]];
    
    
    KMWebViewController * webViewController = [[KMWebViewController alloc]init];
    webViewController.urlString = urlString;
    webViewController.userInfoModel = self.userInfoModel;
    [self.fromVC.navigationController pushViewController:webViewController animated:true];
    
}

-(NSString*)spliceStringFromDictionary:(NSDictionary *)dic {
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    for (NSString * key in  dic.allKeys) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [muArr addObject:str];
    }
    return [muArr componentsJoinedByString:@"&"];
}
@end
