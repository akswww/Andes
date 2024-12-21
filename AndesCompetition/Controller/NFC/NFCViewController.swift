//
//  NFCViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/7/10.
//

import UIKit
import CoreNFC

class NFCViewController: BaseViewController {
    
    struct Node: Codable {
        
    }
   
    var manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbarGradientColor()
        alertNFC()
    }

    func alertNFC() {
        let request: Node = Node()
        Alert.showAlert(title: "", message: "請掃描 NFC", vc: self, confirmTitle: "再試一次",cancelTitle: "確定",confirmAction: {
            Task {
                let result: BaseReponse = try await self.manager.requestData(method: .post, path:.nfcRead, parameters: request)
                if(result.result == 0) {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.alertNFC()
                }
            }
        }) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

