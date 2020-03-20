//
//  KMModels.h
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/17.
//  Copyright © 2020 zhenlove. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMUserInfoModel : NSObject

@property (nonatomic, assign) NSInteger CheckState;
@property (nonatomic, assign) BOOL ConsulAptitude;
@property (nonatomic, assign) NSInteger Gender;
@property (nonatomic, assign) NSInteger IDType;
@property (nonatomic, assign) NSInteger Identifier;
@property (nonatomic, assign) BOOL IsNewUser;
@property (nonatomic, assign) BOOL IsOpenPharmacistSF;
@property (nonatomic, strong) NSString * MemberID;
@property (nonatomic, strong) NSString * Mobile;
@property (nonatomic, strong) NSString * OrgID;
@property (nonatomic, assign) NSInteger PharmacistType;
@property (nonatomic, strong) NSString * PhotoUrl;
@property (nonatomic, assign) BOOL RecipeDoctor;
@property (nonatomic, strong) NSString * RegTime;
@property (nonatomic, strong) NSString * UserCNName;
@property (nonatomic, strong) NSString * UserENName;
@property (nonatomic, strong) NSString * UserID;
@property (nonatomic, strong) NSString * UserToken;
@property (nonatomic, assign) NSInteger UserType;
@end

@interface KMIMConfigModel : NSObject
@property (nonatomic, copy) NSString * sdkAppID;
@property (nonatomic, copy) NSString * userSig;
@property (nonatomic, copy) NSString * identifier;
@property (nonatomic, copy) NSString * accountType;

@end

@interface KMILiveConfig : NSObject

@property (nonatomic, assign) NSInteger AccountType;
@property (nonatomic, strong) NSString * ChannelID;
@property (nonatomic, strong) NSString * Identifier;
@property (nonatomic, strong) NSString * ManageSessId;
@property (nonatomic, strong) NSString * PrivMapEncrypt;
@property (nonatomic, assign) NSInteger SdkAppID;
@property (nonatomic, strong) NSString * UserSig;
@end

@interface KMMediaConfigModel : NSObject
@property (nonatomic, strong) NSString * AppID;
@property (nonatomic, assign) BOOL Audio;
@property (nonatomic, assign) BOOL DisableWebSdkInteroperability;
@property (nonatomic, assign) NSInteger Duration;
@property (nonatomic, strong) KMILiveConfig * ILiveConfig;
@property (nonatomic, strong) NSString * MediaChannelKey;
@property (nonatomic, strong) NSString * RecordingKey;
@property (nonatomic, assign) BOOL Screen;
@property (nonatomic, strong) NSString * Secret;
@property (nonatomic, assign) NSInteger TotalTime;
@property (nonatomic, assign) BOOL Video;
@end

NS_ASSUME_NONNULL_END
