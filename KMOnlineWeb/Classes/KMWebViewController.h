//
//  KMWebViewController.h
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/17.
//  Copyright © 2020 zhenlove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMModels.h"
NS_ASSUME_NONNULL_BEGIN

@interface KMWebViewController : UIViewController
@property (nonatomic,strong) KMUserInfoModel * userInfoModel;
@property (nonatomic,strong) NSString * urlString;
@property (nonatomic, readonly) NSString * callName;
@property (nonatomic, readonly) NSString * callImage;
@end




NS_ASSUME_NONNULL_END
