//
//  WaitRoomController.swift
//  KMOnlineWeb
//
//  Created by Ed on 2020/4/2.
//

import UIKit
import KMAgoraRtc
import KMNetwork
import KMTIMSDK
import Kingfisher

enum RoomState: Int {
    case invalid = -1
    case noVisit = 0 // 未就诊
    case waiting = 1 // 候诊中
    case consulting = 2 // 就诊中
    case consulted = 3 // 已就诊
    case calling = 4 // 呼叫中
    case leaving = 5 // 离开中
    case patientsLeaving = 6 // 患者离开
}


@objc(WaitRoomController)
class WaitRoomController: UIViewController,KMCallInfoModel {
    var callName: String?
    var callImage: String?
    var doctorID: String?
    var channleID: Int?
    var identifier: String?
    var mediaConfigModel: MediaConfigModel!
    
    
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var waitNumber: UILabel!
    
    @IBAction func clickeBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: NSStringFromClass(WaitRoomController.self), bundle: WaitRoomController.bundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        KMFloatViewManager.sharedInstance.delegate = self
        KMIMManager.sharedInstance.delegate = self
        getMediaConfig()
        getWaitPeopleNumber(doctorID, channleID)
        doctorName.text = callName
        if let image = callImage {
            doctorImageView.kf.setImage(with: URL(string: image))
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
    }
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            updateChatRoom(mediaConfigModel.ILiveConfig?.ChannelID, .noVisit)
        }
    }

    /// 获取媒体配置
    func getMediaConfig() {
        let url = KMServiceModel.sharedInstance().baseURL + "/IM/MediaConfig"
        if let channleid = channleID,
            let identifier = identifier {
            let  dic:[String: Any] = ["ChannelID":channleid,"Identifier":identifier]
            KMNetwork
            .sessionManager
            .request(url, method: .get, parameters: dic)
            .validateDataStatus(statusCode: [5, -5])
            .responseObject(RootClass<MediaConfigModel>.self) { [weak self] response in
                switch response.result {
                case .success(let model):
                    print("获取媒体配置成功")
                    self?.mediaConfigModel = model.Data
                    self?.updateChatRoom(model.Data?.ILiveConfig?.ChannelID, .waiting)
                case .failure(let error):
                    print("获取媒体配置失败%@", error.localizedDescription)
                }
            }
        }
    }
    
    /// 设置房间状态
    func updateChatRoom(_ channleID: String?, _ state: RoomState) {
        let url = KMServiceModel.sharedInstance().baseURL + "/IM/Room/State"
        if let channleId = channleID,
            let id = Int(channleId) {
            let dic:[String: Any] = ["ChannelID": id, "State": state.rawValue]
            KMNetwork
            .sessionManager
            .request(url, method: .put, parameters: dic)
            .validateDataStatus(statusCode: [5, -5])
            .responseObject(RootClass<Int>.self) { response in
                switch response.result {
                case .success:
                    print("设置房间状态--成功")
                case .failure(let error):
                    print("设置房间状态--失败%@",error.localizedDescription)
                }
            }
        }
    }

    /// 获取候诊人数
    func getWaitPeopleNumber(_ doctorID:String?,_ channelID:Int?) {
        let url = KMServiceModel.sharedInstance().baseURL + "/IM/Room/WaitingCount"
        var dic:[String:Any] = [:]
        if let doctorId = doctorID {
            dic["DoctorID"] = doctorId
        }
        if let channelId = channelID {
            dic["ChannelID"] = channelId
        }
        KMNetwork
        .sessionManager
        .request(url, method: .get, parameters: dic)
        .validateDataStatus(statusCode: [5, -5])
        .responseObject(RootClass<Int>.self) { [weak self] (response) in
            switch response.result {
            case .success(let result):
                if let number = result.Data {
                    let str = "您前面还有 \(number) 位候诊人"
                    if let range = str.nsRange(from: str.range(of: "\(number)")) {
                        let attriStr = NSMutableAttributedString(string: str)
                        let dic = [NSAttributedString.Key.foregroundColor : UIColor.blue,
                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]
                        attriStr.addAttributes(dic, range: range)
                        self?.waitNumber.attributedText = attriStr
                    }
                }
            case .failure(let error):
                print("获取候诊人数--失败%@",error.localizedDescription)
            }
        }
        
    }
    
    /// 退出候诊室
    func showTipInquiry() {
        let alert = UIAlertController(title: "温馨提示", message: "确定要退出本次问诊？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            self?.updateChatRoom(self?.mediaConfigModel.ILiveConfig?.ChannelID, .waiting)
            KMFloatViewManager.sharedInstance.dissView()
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        navigationController?.present(alert, animated: true, completion: nil)
    }

}
extension String {
    func nsRange(from range: Range<String.Index>?) -> NSRange? {
        
        if let rag = range,
            let from = rag.lowerBound.samePosition(in: utf16),
                let to = rag.upperBound.samePosition(in: utf16) {
                    return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),length: utf16.distance(from: from, to: to))
        }
        return nil
    }
}
extension WaitRoomController {
    static func bundle() -> Bundle? {
        if let url = Bundle(for: WaitRoomController.self).url(forResource: "KMOnlineWeb", withExtension: "bundle") {
            return Bundle(url: url)
        }
        return Bundle(for: WaitRoomController.self)
    }
}
extension WaitRoomController: KMFloatViewManagerDelegate {
    func clickedHangupButton() {
        showTipInquiry()
        print("挂断")
    }
    
    func clickedPrescribeButton() {
        print("开处方")
    }
}
extension WaitRoomController:RoomStateListenerDelegate {
    func listener(channelID: Int?, customElem: RoomStateChanged) {
        if channelID == self.channleID {
            if let state = customElem.State {
                if  RoomState.init(rawValue: state) == .calling {
                    let callSystem = KMCallingSystemController()
                    callSystem.modalPresentationStyle = .fullScreen
                    callSystem.delegate = self
                    callSystem.userDelegate = self
                    present(callSystem, animated: true, completion: nil)
                }
            }
        }
    }
}
extension WaitRoomController: KMCallingSystemOperationDelegate {
    func answerCallingInKMCallingOperation() {
        updateChatRoom(mediaConfigModel.ILiveConfig?.ChannelID, .consulting)
        if let channelID = mediaConfigModel.ILiveConfig?.ChannelID {
            
            let chat = IMChatController()
            chat.convId = channelID
            chat.delegate = self
            chat.title = "视频问诊"
            navigationController?.pushViewController(chat, animated: true)
            
            if let id = mediaConfigModel.ILiveConfig?.Identifier,
                let identifier = UInt(id),
                    let key = mediaConfigModel.MediaChannelKey,
                        let appid = mediaConfigModel.AppID {
                            KMFloatViewManager
                            .sharedInstance
                            .showView(channelKey: key, channelId: channelID, userId: identifier, appId: appid, userType: 1)
            }
        }
    }
    
    func rejectedCallingInKMCallingOperation() {
        updateChatRoom(mediaConfigModel.ILiveConfig?.ChannelID, .waiting)
    }
}

extension WaitRoomController:IMChatControllerDelegate {
    func clickeBackBtnController() -> Bool {
        if KMFloatViewManager.sharedInstance.isShow {
            showTipInquiry()
            return false
        } else {
            return true
        }
    }
    
    func clickePatientInfo(_ infoDic: [String : Any]) {
        if let block = OnlineWebManager.sharedInstance.patientInfoBlock {
            block(infoDic)
        }
    }
    
    func clickePrescribe(_ prescribeUrl: String?, _ opdRegisterID: String?) {
        if let block = OnlineWebManager.sharedInstance.prescribeBlock {
            block(prescribeUrl,opdRegisterID)
        }
    }
    
}
