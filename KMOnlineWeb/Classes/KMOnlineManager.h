//
//  KMOnlineManager.h
//  KMOnlineWeb
//
//  Created by Ed on 2020/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMOnlineManager : NSObject
+ (instancetype)sharedInstance;
- (void)reloadWebViewWithUrl:(NSString *)url withDic:(NSDictionary *)dic showViewController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
