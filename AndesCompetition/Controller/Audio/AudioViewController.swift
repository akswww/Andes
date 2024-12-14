//
//  AudioViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/9/4.
//

import UIKit

class AudioViewController: UIViewController {

    var first = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        SpeechManager.shared.textUpdateHandler = { text, t in
                    print(text)
            }
    }

    @IBAction func startListen(_ sender: UIButton) {
        self.first.toggle()
        if(first) {
            SpeechManager.shared.checkPermissions { granted in
                if granted {
//                    SpeechManager.shared.startRecordingCn()
//                    SpeechManager.shared.startRecordingEn()
                } else {
                    print("未獲得語音辨識權限")
                }
                
            }
        } else {
            SpeechManager.shared.stopRecording()
        }
    }
    
}
