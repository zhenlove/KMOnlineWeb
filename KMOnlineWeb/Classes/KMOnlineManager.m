//
//  KMOnlineManager.m
//  KMOnlineWeb
//
//  Created by Ed on 2020/3/19.
//

#import "KMOnlineManager.h"
#import <MJExtension/MJExtension.h>
#import "KMModels.h"
#import "KMWebViewController.h"
#import <KMNavigationExtension/JZNavigationExtension.h>
@import KMNetwork;

@interface KMOnlineManager()
@property (nonatomic,strong) KMUserInfoModel * userInfoModel;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,weak) UIViewController * fromVC;
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
    
    __weak typeof(self)weakSelf = self;
    NSString * urls = [[KMServiceModel sharedInstance].baseURL stringByAppendingString:@"/users/InterLoginNoAccount"];
    [KMNetwork requestWithUrl:urls
                       method:@"POST"
                   parameters:dic
                   isHttpBody:false
                requestSucess:^(NSHTTPURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable result) {
        
        weakSelf.userInfoModel = [KMUserInfoModel mj_objectWithKeyValues:result[@"Data"]];
        [KMServiceModel sharedInstance].usertoken = weakSelf.userInfoModel.UserToken;
        [weakSelf showViewController];
        
    } requestFailure:^(NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"登录失败");
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
    webViewController.jz_navigationBarHidden = true;
    self.fromVC.navigationController.jz_navigationBarHidden = false;
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
