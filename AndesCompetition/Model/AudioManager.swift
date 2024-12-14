//
//  Audio.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/9/4.
//

import UIKit
import Speech
import AVFoundation

import UIKit
import Speech
import AVFoundation

class SpeechManager: NSObject {
    
    static let shared = SpeechManager()
    
    private let speechRecognizerTW = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))!
    private let speechRecognizerEN = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionRequest1: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTaskTW: SFSpeechRecognitionTask?
    private var recognitionTaskEN: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let audioEngine1 = AVAudioEngine()
    var textUpdateHandler: ((String, Bool) -> Void)?
    
    private override init() {
        super.init()
        speechRecognizerTW.delegate = self
        speechRecognizerEN.delegate = self
    }
    
    func checkPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus == .authorized)
            }
        }
    }
    
    func startRecordingCn() {
        stopRecording()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("設置音訊會話屬性時發生錯誤：\(error)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("無法創建 SFSpeechAudioBufferRecognitionRequest 物件")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        DispatchQueue.global(qos: .background).async { [self] in
            startRecognitionTask(for: speechRecognizerTW, isChineseTask: true)
        }
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("音訊引擎無法啟動：\(error)")
        }
        
        textUpdateHandler?("請說話，我正在聆聽...", true)
    }
    
    func startRecordingEn() {
        stopRecording()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("設置音訊會話屬性時發生錯誤：\(error)")
            return
        }
        
        recognitionRequest1 = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest1 else {
            fatalError("無法創建 SFSpeechAudioBufferRecognitionRequest 物件")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        DispatchQueue.global(qos: .background).async { [self] in
            startRecognitionTask1(for: speechRecognizerEN, isChineseTask: false)
        }
        let recordingFormat = audioEngine1.inputNode.outputFormat(forBus: 0)
        audioEngine1.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest1?.append(buffer)
        }
        
        audioEngine1.prepare()
        
        do {
            try audioEngine1.start()
        } catch {
            print("音訊引擎無法啟動：\(error)")
        }
        
        textUpdateHandler?("請說話，我正在聆聽...", true)
    }
    
    private func startRecognitionTask1(for recognizer: SFSpeechRecognizer, isChineseTask: Bool) {
        guard let recognitionRequest = recognitionRequest1 else { return }
        
        let task = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            print("test")
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.textUpdateHandler?(text, isChineseTask)
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
                self.textUpdateHandler?("語音辨識已停止", isChineseTask)
            }
        }
        
        if isChineseTask {
            recognitionTaskTW = task
        } else {
            recognitionTaskEN = task
        }
    }
    
    
    private func startRecognitionTask(for recognizer: SFSpeechRecognizer, isChineseTask: Bool) {
        guard let recognitionRequest = recognitionRequest else { return }
        
        let task = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            print("test1")
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.textUpdateHandler?(text, isChineseTask)
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
                self.textUpdateHandler?("語音辨識已停止", isChineseTask)
            }
        }
        
        if isChineseTask {
            recognitionTaskTW = task
        } else {
            recognitionTaskEN = task
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine1.stop()
        audioEngine1.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest1?.endAudio()
        recognitionTaskTW?.cancel()
        recognitionTaskEN?.cancel()
        recognitionRequest = nil
        recognitionRequest1 = nil
        recognitionTaskTW = nil
        recognitionTaskEN = nil
    }
}

extension SpeechManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("語音辨識器現在可用")
        } else {
            print("語音辨識器目前不可用")
        }
    }
}
