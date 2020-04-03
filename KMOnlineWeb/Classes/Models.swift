//
//  Models.swift
//  KMOnlineWeb
//
//  Created by Ed on 2020/4/1.
//

import Foundation
struct RootClass<T: Codable>: Codable {
    let Data: T?
    let Msg: String?
    let Result: Bool?
    let Status: Int?
    let Total: Int?
}

struct UserInfoModel: Codable {
    let CheckState: Int?
    let ConsulAptitude: Bool?
    let Gender: Int?
    let IDType: Int?
    let Identifier: Int?
    let IsNewUser: Bool?
    let IsOpenPharmacistSF: Bool?
    let MemberID: String?
    let Mobile: String?
    let OrgID: String?
    let PharmacistType: Int?
    let PhotoUrl: String?
    let RecipeDoctor: Bool?
    let RegTime: String?
    let UserCNName: String?
    let UserENName: String?
    let UserID: String?
    let UserToken: String?
    let UserType: Int?
}

struct ImConfigModel: Codable {
    let accountType: Int?
    let identifier: String?
    let manageSessId: String?
    let sdkAppID: Int?
    let userSig: String?
}

struct IliveConfig: Codable {
    let AccountType: Int?
    let ChannelID: String?
    let Identifier: String?
    let ManageSessId: String?
    let PrivMapEncrypt: String?
    let SdkAppID: Int?
    let UserSig: String?
}

struct MediaConfigModel: Codable {
    let AppID: String?
    let Audio: Bool?
    let DisableWebSdkInteroperability: Bool?
    let Duration: Int?
    let ILiveConfig: IliveConfig?
    let MediaChannelKey: String?
    let RecordingKey: String?
    let Screen: Bool?
    let Secret: String?
    let TotalTime: Int?
    let Video: Bool?
}

