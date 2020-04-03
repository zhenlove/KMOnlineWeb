//
//  WebViewController.swift
//  KMOnlineWeb
//
//  Created by Ed on 2020/4/1.
//

import Foundation
import KMNetwork
import KMTIMSDK


class WebViewController: UIViewController {
    public var callName: String?
    public var callImage: String?
    public var userInfoModel: UserInfoModel!
    public var urlString: String!
    
    var imConfigModel: ImConfigModel!
    
    lazy var webView: WebView = {
        let web = WebView.sharedInstance
        web.webView.backgroundColor = UIColor.white
        web.model.delegate = self
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.delegate = self
                
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        webView.frame = CGRect(x: 0, y: statusHeight, width: screenWidth, height: screenHeight - statusHeight)
        view.addSubview(webView)
        
        webView.setUrlStr(urlStr: urlString)
        webView.loadRequest()
        requestIMConfig()
    }
    
    /// 获取IM配置
    func requestIMConfig() {
        let url = KMServiceModel.sharedInstance().baseURL + "/IM/Config"
        KMNetwork
            .sessionManager
            .request(url, method: .get, parameters: nil)
            .validateDataStatus(statusCode: [5, -5])
            .responseObject(RootClass<ImConfigModel>.self) { [weak self] response in
                switch response.result {
                case .success(let model):
                    print("获取IM配置成功")
                    self?.imConfigModel = model.Data
                    self?.loginIM()
                case .failure(let error):
                    print("获取IM配置失败%@", error.localizedDescription)
                }
            }
    }
    
    /// 登录IM
    func loginIM() {
        let manager = KMTIMManager.sharedInstance()
        manager.setup(withAppId: imConfigModel.sdkAppID!,
                      userSig: imConfigModel.userSig!,
                      andIdentifier: imConfigModel.identifier!)
        manager.login(ofSucc: {
            print("IM登录成功")
            let dic = [TIMProfileTypeKey_Nick: self.userInfoModel.UserCNName!,
                       TIMProfileTypeKey_FaceUrl: self.userInfoModel.PhotoUrl!]
            TIMFriendshipManager.sharedInstance()?.modifySelfProfile(dic, succ: {
                print("IM设置资料成功")
            }, fail: { code, msg in
                print("IM设置资料失败 code:\(code) msg:\(String(describing: msg))")
            })
        }) { code, msg in
            print("IM登录失败 code:\(code) msg:\(String(describing: msg))")
        }
    }
    
}

extension WebViewController: JSCallBackDelegate {
    func jsCallChatWithParameterDictionary(_ pDictionary: [String : AnyObject]) {
        if let channelID = pDictionary["ChanelId"] as? Int,
            let consultState = pDictionary["ConsultState"] as? Int,
                let state = KMConsultationState(rawValue: consultState) {
                    let chat = KMChatController()
                    chat.convId = "\(channelID)"
                    chat.consulationState = state
                    chat.title = "图文问诊"
                    chat.delegate = self
                    navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    func jsCallAudioOrVideoWithParameterDictionary(_ pDictionary: [String : AnyObject]) {
        let waitRoom = WaitRoomController()
        waitRoom.callName = pDictionary["UserName"] as? String
        waitRoom.callImage = pDictionary["UserFace"] as? String
        waitRoom.channleID = pDictionary["ChannelID"] as? Int
        waitRoom.doctorID = pDictionary["UserID"] as? String
        waitRoom.identifier = imConfigModel.identifier
        navigationController?.pushViewController(waitRoom, animated: true)
    }
    
    func jsCallBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func jsRefreshLoginInfo() {
        let loginInfo = ["AppKey": KMServiceModel.sharedInstance().appKey,
                         "AppToken": KMServiceModel.sharedInstance().apptoken,
                         "UserToken": KMServiceModel.sharedInstance().usertoken,
                         "OrgId": KMServiceModel.sharedInstance().orgId,
                         "Platform": "ios"]
        webView.refreshLoginInfoWithJSONString(toJsonString(loginInfo))
    }
    
    func toJsonString(_ dic: [String: String?]) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted),
            let json = String(data: data, encoding: .utf8) {
            return json
        } else {
            return "转json失败"
        }
    }
}

extension WebViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.isKind(of: WebViewController.self), animated: true)
    }
}



extension WebViewController: KMChatControllerDelegate {
    func clickePatientInfo(_ patientInfoDic: [AnyHashable: Any]!) {
        let infoVC = KMPatientInfoVC()
        infoVC.userInfoDic = patientInfoDic
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func clickePrescribe(_ prescribeUrl: String!, oPDRegisterID OPDRegisterID: String!) {
        let web = KMIMWebViewController()
        web.prescribeUrl = prescribeUrl
        navigationController?.pushViewController(web, animated: true)
    }
    
    func clickeBackBtnController() -> Bool {
        return true
    }
}
