//
//  NFCViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/7/10.
//

import UIKit
import CoreNFC

class NFCViewController: BaseViewController {
    
    var name: String?
    
    var tall: Double?
    
    var weight: Double?
    
    var idcard: String?
    
    var birther: String?
    
    var genderStr: String?
    
    private let nfcManager = CoreNFCManager.shared
    
    private var detectedTag: (any NFCNDEFTag)?
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbarGradientColor()
        self.title = "NFC感應"
        nfcManager.delegate = self
        CoreNFCManager.shared.isSupportNFC()
    }

    func writeToNFCTag(_ message: NFCNDEFMessage) async {
        guard let tag = detectedTag else {
            print("未檢測到 NFC 標籤")
            return
        }
        do {
            try await nfcManager.write(tag: tag, data: message)
        } catch {
            Alert.showAlert(title: "錯誤",
                            message: "寫入 NFC 標籤失敗：\(error.localizedDescription)",
                            vc: self,
                            confirmTitle: "確定") { [self] in 
                nfcManager.scanNFC()
            }
        }
    }
  
}

extension NFCViewController: CoreNFCManagerDelegate {
    func session(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        Alert.showAlert(title: "\(Error.self)",
                        message: "Session 無效，錯誤：" + error.localizedDescription,
                        vc: self,
                        confirmTitle: "確認")
        
    }
    
    func session(_ session: NFCNDEFReaderSession, didDetect tag: any NFCNDEFTag) async {
        self.detectedTag = tag
        
        let newMessage = NFCNDEFMessage(records: [
            NFCNDEFPayload(format: .unchanged,
                           type: "com.example.payload12".data(using: .utf8)!,
                           identifier: "example-identifier12".data(using: .utf8)!,
                           payload: "姓名: \(name!)\n 身高: \(tall!)\n 體重: \(weight!)\n 身分證: \(idcard!)\n 生日: \(birther!)\n 性別: \(genderStr!)".data(using: .utf8)!)
        ])
//        let newMessage = NFCNDEFMessage(records: [
//            NFCNDEFPayload(format: .unchanged,
//                           type: "com.example.payload12".data(using: .utf8)!,
//                           identifier: "example-identifier12".data(using: .utf8)!,
//                           payload: "eew: sss\n ww: 123 \n 112: 11\n wee: G223 \n gg: www\n 23: wqe".data(using: .utf8)!)
//        ])
        await writeToNFCTag(newMessage)
        
        Task {
            let message = try? await tag.readNDEF()
            if let records = message?.records {
                for (index, record) in records.enumerated() {
                    print("記錄 \(index + 1):")
                    print("類型名稱: \(record.typeNameFormat.rawValue)")
                    print("類型: \(String(data: record.type, encoding: .utf8) ?? "未知")")
                    print("識別碼: \(String(data: record.identifier, encoding: .utf8) ?? "無")")
                    print("負載: \(String(data: record.payload, encoding: .utf8) ?? "無法解碼")")
                    print("---")
                }
            } else {
                print("卡片中沒有 NDEF 訊息")
            }
            session.invalidate()
        }
    }
}
