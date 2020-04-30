//
//  OnlineWebManager.swift
//  KMOnlineWeb
//
//  Created by Ed on 2020/3/31.
//

import Foundation
import KMNetwork

public typealias funcPatientInfoBlock = (_ info:[String:Any]) -> Void
public typealias funcPrescribeBlock = (_ url:String?,_ opdRegisterID:String?) -> Void

@objc open class OnlineWebManager: NSObject {
    var baseUrl: String!
    var navControl: UINavigationController!
    var userInfoModel: UserInfoModel!
    @objc public var patientInfoBlock:funcPatientInfoBlock?
    @objc public var prescribeBlock:funcPrescribeBlock?
    @objc public static let sharedInstance: OnlineWebManager = {
        OnlineWebManager()
    }()
    
    @objc public func reloadWebView(Url url: String, userInfoDic dic: [String: Any], fromNavControl fromVC: UINavigationController) {
        baseUrl = url
        navControl = fromVC
        loginOnline(dic)
    }
    
    func loginOnline(_ param: [String: Any]) {
        let url = KMServiceModel.sharedInstance().baseURL + "/users/InterLoginNoAccount"
        
        KMNetwork
            .sessionManager
            .request(url, method: .post, parameters: param)
            .validateDataStatus(statusCode: [5, -5])
            .responseObject(RootClass<UserInfoModel>.self) { [weak self] response in
                switch response.result {
                case .success(let model):
                    print("登录成功")
                    self?.userInfoModel = model.Data
                    KMServiceModel.sharedInstance().usertoken = model.Data?.UserToken
                    self?.showViewController()
                case .failure(let error):
                    print("登录失败%@", error.localizedDescription)
                }
            }
    }
    
    func showViewController() {
        let dic = ["AppKey": KMServiceModel.sharedInstance().appKey,
                   "AppToken": KMServiceModel.sharedInstance().apptoken,
                   "UserToken": KMServiceModel.sharedInstance().usertoken,
                   "OrgId": KMServiceModel.sharedInstance().orgId]
        let url = baseUrl + "?" + spliceString(dic)
        let webVC = WebViewController()
        webVC.urlString = url
        webVC.userInfoModel = userInfoModel
        navControl.pushViewController(webVC, animated: true)
    }
    
    func spliceString(_ dic: [String: String?]) -> String {
        var muArr = [String]()
        for (key, value) in dic {
            muArr.append(key + "=" + value!)
        }
        return muArr.joined(separator: "&")
    }
}
