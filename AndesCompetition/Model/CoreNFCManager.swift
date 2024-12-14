//
//  CoreNFCManager.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/7/11.
//

import CoreNFC

protocol CoreNFCManagerDelegate: NSObjectProtocol {
    
    /// 代理 `func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error)`
    /// - Parameters:
    ///   - session: NFCNDEFReaderSession
    ///   - error: Error
    func session(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error)
    
    /// 代理 `func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag])`
    /// - Parameters:
    ///   - session: NFCNDEFReaderSession
    ///   - tag: NFCNDEFTag
    func session(_ session: NFCNDEFReaderSession, didDetect tag: NFCNDEFTag) async
}

/// 處理 CoreNFC 事件的 Singleton Object
class CoreNFCManager: NSObject {
    
    /// Singleton
    static let shared = CoreNFCManager()
    
    /// CoreNFCManagerDelegate
    weak var delegate: CoreNFCManagerDelegate?
    
    /// NFCNDEFReaderSession
    private var session: NFCNDEFReaderSession?
    
    /// NFCNDEFMessage Encode Error enum
    enum NFCNDEFMessageEncodeError: Error {
        
        /// 字元取代失敗
        case replaceFailed
    }
    
    // MARK: - Function
    
    /// 判斷裝置是否支援 NFC 功能
    func isSupportNFC () {
        if NFCNDEFReaderSession.readingAvailable {
            // 支援 NFC，iPhone 7 以後機型
            CoreNFCManager.shared.session = NFCNDEFReaderSession(delegate: self,
                                                                 queue: nil,
                                                                 invalidateAfterFirstRead: false)
            CoreNFCManager.shared.session?.alertMessage = "將您的 iPhone 靠近該商品以了解有關它的更多信息"
            CoreNFCManager.shared.session?.begin()
        }
    }
    
    func scanNFC() {
            guard NFCNDEFReaderSession.readingAvailable else {
                print("NFC 掃描不可用")
                return
            }
            
            session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: false)
            session?.begin()
        }
    
    /// 對 NFCNDEFMessage 進行編碼
    /// - Parameters
    ///   - message: 要進行編碼的 NFCNDEFMessage
    /// - Returns: 編碼後的 NFCNDEFMessage
    func encode(message: NFCNDEFMessage) -> Result<String, Error> {
        let encodeMessage = String(data: message.records[0].payload, encoding: .utf8)
        
        #if DEBUG
        print("NDEF Encode Message：\(String(describing: encodeMessage))")
        print("type：", String(describing: String(data: message.records[0].type, encoding: .utf8)))
        print("description：", message.records[0].description)
        #endif
        
        guard let results = encodeMessage?
            .replacingOccurrences(of: "\u{02}en", with: "", options: .literal)
            .trimmingCharacters(in: .whitespaces) else {
            print("encodeMessage 字元 replacing 失敗")
            return .failure(NFCNDEFMessageEncodeError.replaceFailed)
        }
        
        #if DEBUG
        print("NDEF Encode Message Replacing：\(results)")
        #endif
        
        return .success(results)
    }
    
    // MARK: - Write NDEFMessage to NFC Card
    
    /// 建立 NFCNDEFMessage
    /// - Parameters
    ///   - payloadData:  要寫入的資料
    /// - Returns: 建立好的 NFCNDEFMessage
    func createNDEFMessage(payloadData: Data) -> NFCNDEFMessage {
        let payload = NFCNDEFPayload(format: .nfcWellKnown,
                                     type: "T".data(using: .utf8)!,
                                     identifier: Data(count: 0),
                                     payload: payloadData,
                                     chunkSize: 0)
        let ndefMessage = NFCNDEFMessage(records: [payload])
        
        return ndefMessage
    }
    
    /// 對 NFC 週邊進行寫入
    /// - Parameters:
    ///   - tag: 要進行寫入的 NFCNDEFTag
    ///   - data: 要寫入的 NFCNDEFMessage 資料
    /// - Throws: 寫入過程中有拋出的 Error
    func write(tag: NFCNDEFTag, data: NFCNDEFMessage) async throws {
        try await tag.writeNDEF(data)
    }
}

// MARK: - NFCNDEFReaderSessionDelegate

extension CoreNFCManager: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead &&
                readerError.code != .readerSessionInvalidationErrorUserCanceled {
                delegate?.session(session, didInvalidateWithError: readerError)
            }
        }
        self.session = nil
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Process detected NFCNDEFMessage objects.
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            // Restart polling in 500ms
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "偵測到超過 1 個標籤，請刪除所有標籤並重試"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        
        // Connect to the found tag and perform NDEF message reading
        guard let tag = tags.first else {
            return
        }
        
        Task {
            do {
                try await session.connect(to: tag)
                do {
                    let (status, _) = try await tag.queryNDEFStatus()
                    guard status != .notSupported else {
                        session.alertMessage = "標籤不符合 NEF 標準"
                        session.invalidate()
                        return
                    }
                    await delegate?.session(session, didDetect: tag)
                } catch {
                    session.alertMessage = "無法查詢標籤的 NDEF 狀態"
                    session.invalidate()
                    return
                }
            } catch {
                session.alertMessage = "無法連接到標籤"
                session.invalidate()
                return
            }
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("readerSessionDidBecomeActive")
    }
}
