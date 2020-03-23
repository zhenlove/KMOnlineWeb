//
//  KMModels.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/17.
//  Copyright © 2020 zhenlove. All rights reserved.
//

#import "KMModels.h"

NSString *const kDataCheckState = @"CheckState";
NSString *const kDataConsulAptitude = @"ConsulAptitude";
NSString *const kDataGender = @"Gender";
NSString *const kDataIDType = @"IDType";
NSString *const kDataIdentifier = @"Identifier";
NSString *const kDataIsNewUser = @"IsNewUser";
NSString *const kDataIsOpenPharmacistSF = @"IsOpenPharmacistSF";
NSString *const kDataMemberID = @"MemberID";
NSString *const kDataMobile = @"Mobile";
NSString *const kDataOrgID = @"OrgID";
NSString *const kDataPharmacistType = @"PharmacistType";
NSString *const kDataPhotoUrl = @"PhotoUrl";
NSString *const kDataRecipeDoctor = @"RecipeDoctor";
NSString *const kDataRegTime = @"RegTime";
NSString *const kDataUserCNName = @"UserCNName";
NSString *const kDataUserENName = @"UserENName";
NSString *const kDataUserID = @"UserID";
NSString *const kDataUserToken = @"UserToken";
NSString *const kDataUserType = @"UserType";

NSString *const kDataaccountType = @"accountType";
NSString *const kDataidentifier = @"identifier";
NSString *const kDatamanageSessId = @"manageSessId";
NSString *const kDatasdkAppID = @"sdkAppID";
NSString *const kDatauserSig = @"userSig";

NSString *const kDataAppID = @"AppID";
NSString *const kDataAudio = @"Audio";
NSString *const kDataDisableWebSdkInteroperability = @"DisableWebSdkInteroperability";
NSString *const kDataDuration = @"Duration";
NSString *const kDataILiveConfig = @"ILiveConfig";
NSString *const kDataMediaChannelKey = @"MediaChannelKey";
NSString *const kDataRecordingKey = @"RecordingKey";
NSString *const kDataScreen = @"Screen";
NSString *const kDataSecret = @"Secret";
NSString *const kDataTotalTime = @"TotalTime";
NSString *const kDataVideo = @"Video";

NSString *const kILiveConfigAccountType = @"AccountType";
NSString *const kILiveConfigChannelID = @"ChannelID";
NSString *const kILiveConfigIdentifier = @"Identifier";
NSString *const kILiveConfigManageSessId = @"ManageSessId";
NSString *const kILiveConfigPrivMapEncrypt = @"PrivMapEncrypt";
NSString *const kILiveConfigSdkAppID = @"SdkAppID";
NSString *const kILiveConfigUserSig = @"UserSig";

@implementation KMUserInfoModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kDataCheckState] isKindOfClass:[NSNull class]]){
        self.CheckState = [dictionary[kDataCheckState] integerValue];
    }

    if(![dictionary[kDataConsulAptitude] isKindOfClass:[NSNull class]]){
        self.ConsulAptitude = [dictionary[kDataConsulAptitude] boolValue];
    }

    if(![dictionary[kDataGender] isKindOfClass:[NSNull class]]){
        self.Gender = [dictionary[kDataGender] integerValue];
    }

    if(![dictionary[kDataIDType] isKindOfClass:[NSNull class]]){
        self.IDType = [dictionary[kDataIDType] integerValue];
    }

    if(![dictionary[kDataIdentifier] isKindOfClass:[NSNull class]]){
        self.Identifier = [dictionary[kDataIdentifier] integerValue];
    }

    if(![dictionary[kDataIsNewUser] isKindOfClass:[NSNull class]]){
        self.IsNewUser = [dictionary[kDataIsNewUser] boolValue];
    }

    if(![dictionary[kDataIsOpenPharmacistSF] isKindOfClass:[NSNull class]]){
        self.IsOpenPharmacistSF = [dictionary[kDataIsOpenPharmacistSF] boolValue];
    }

    if(![dictionary[kDataMemberID] isKindOfClass:[NSNull class]]){
        self.MemberID = dictionary[kDataMemberID];
    }
    if(![dictionary[kDataMobile] isKindOfClass:[NSNull class]]){
        self.Mobile = dictionary[kDataMobile];
    }
    if(![dictionary[kDataOrgID] isKindOfClass:[NSNull class]]){
        self.OrgID = dictionary[kDataOrgID];
    }
    if(![dictionary[kDataPharmacistType] isKindOfClass:[NSNull class]]){
        self.PharmacistType = [dictionary[kDataPharmacistType] integerValue];
    }

    if(![dictionary[kDataPhotoUrl] isKindOfClass:[NSNull class]]){
        self.PhotoUrl = dictionary[kDataPhotoUrl];
    }
    if(![dictionary[kDataRecipeDoctor] isKindOfClass:[NSNull class]]){
        self.RecipeDoctor = [dictionary[kDataRecipeDoctor] boolValue];
    }

    if(![dictionary[kDataRegTime] isKindOfClass:[NSNull class]]){
        self.RegTime = dictionary[kDataRegTime];
    }
    if(![dictionary[kDataUserCNName] isKindOfClass:[NSNull class]]){
        self.UserCNName = dictionary[kDataUserCNName];
    }
    if(![dictionary[kDataUserENName] isKindOfClass:[NSNull class]]){
        self.UserENName = dictionary[kDataUserENName];
    }
    if(![dictionary[kDataUserID] isKindOfClass:[NSNull class]]){
        self.UserID = dictionary[kDataUserID];
    }
    if(![dictionary[kDataUserToken] isKindOfClass:[NSNull class]]){
        self.UserToken = dictionary[kDataUserToken];
    }
    if(![dictionary[kDataUserType] isKindOfClass:[NSNull class]]){
        self.UserType = [dictionary[kDataUserType] integerValue];
    }

    return self;
}

@end

@implementation KMIMConfigModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kDataaccountType] isKindOfClass:[NSNull class]]){
        self.accountType = [dictionary[kDataaccountType] stringValue];
    }

    if(![dictionary[kDataidentifier] isKindOfClass:[NSNull class]]){
        self.identifier = dictionary[kDataidentifier];
    }
    if(![dictionary[kDatamanageSessId] isKindOfClass:[NSNull class]]){
        self.manageSessId = dictionary[kDatamanageSessId];
    }
    if(![dictionary[kDatasdkAppID] isKindOfClass:[NSNull class]]){
        self.sdkAppID = [dictionary[kDatasdkAppID] stringValue];
    }

    if(![dictionary[kDatauserSig] isKindOfClass:[NSNull class]]){
        self.userSig = dictionary[kDatauserSig];
    }
    return self;
}

@end

@implementation KMILiveConfig
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kILiveConfigAccountType] isKindOfClass:[NSNull class]]){
        self.AccountType = [dictionary[kILiveConfigAccountType] integerValue];
    }

    if(![dictionary[kILiveConfigChannelID] isKindOfClass:[NSNull class]]){
        self.ChannelID = dictionary[kILiveConfigChannelID];
    }
    if(![dictionary[kILiveConfigIdentifier] isKindOfClass:[NSNull class]]){
        self.Identifier = dictionary[kILiveConfigIdentifier];
    }
    if(![dictionary[kILiveConfigManageSessId] isKindOfClass:[NSNull class]]){
        self.ManageSessId = dictionary[kILiveConfigManageSessId];
    }
    if(![dictionary[kILiveConfigPrivMapEncrypt] isKindOfClass:[NSNull class]]){
        self.PrivMapEncrypt = dictionary[kILiveConfigPrivMapEncrypt];
    }
    if(![dictionary[kILiveConfigSdkAppID] isKindOfClass:[NSNull class]]){
        self.SdkAppID = [dictionary[kILiveConfigSdkAppID] integerValue];
    }

    if(![dictionary[kILiveConfigUserSig] isKindOfClass:[NSNull class]]){
        self.UserSig = dictionary[kILiveConfigUserSig];
    }
    return self;
}

@end

@implementation KMMediaConfigModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kDataAppID] isKindOfClass:[NSNull class]]){
        self.AppID = dictionary[kDataAppID];
    }
    if(![dictionary[kDataAudio] isKindOfClass:[NSNull class]]){
        self.Audio = [dictionary[kDataAudio] boolValue];
    }

    if(![dictionary[kDataDisableWebSdkInteroperability] isKindOfClass:[NSNull class]]){
        self.DisableWebSdkInteroperability = [dictionary[kDataDisableWebSdkInteroperability] boolValue];
    }

    if(![dictionary[kDataDuration] isKindOfClass:[NSNull class]]){
        self.Duration = [dictionary[kDataDuration] integerValue];
    }

    if(![dictionary[kDataILiveConfig] isKindOfClass:[NSNull class]]){
        self.ILiveConfig = [[KMILiveConfig alloc] initWithDictionary:dictionary[kDataILiveConfig]];
    }

    if(![dictionary[kDataMediaChannelKey] isKindOfClass:[NSNull class]]){
        self.MediaChannelKey = dictionary[kDataMediaChannelKey];
    }
    if(![dictionary[kDataRecordingKey] isKindOfClass:[NSNull class]]){
        self.RecordingKey = dictionary[kDataRecordingKey];
    }
    if(![dictionary[kDataScreen] isKindOfClass:[NSNull class]]){
        self.Screen = [dictionary[kDataScreen] boolValue];
    }

    if(![dictionary[kDataSecret] isKindOfClass:[NSNull class]]){
        self.Secret = dictionary[kDataSecret];
    }
    if(![dictionary[kDataTotalTime] isKindOfClass:[NSNull class]]){
        self.TotalTime = [dictionary[kDataTotalTime] integerValue];
    }

    if(![dictionary[kDataVideo] isKindOfClass:[NSNull class]]){
        self.Video = [dictionary[kDataVideo] boolValue];
    }

    return self;
}
@end
