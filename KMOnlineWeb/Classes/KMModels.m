//
//  KMModels.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/17.
//  Copyright © 2020 zhenlove. All rights reserved.
//

#import "KMModels.h"

@implementation KMUserInfoModel
@end

@implementation KMIMConfigModel
@end

@implementation KMILiveConfig
@end

@implementation KMMediaConfigModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"ILiveConfig":@"KMILiveConfig"};
}
@end
