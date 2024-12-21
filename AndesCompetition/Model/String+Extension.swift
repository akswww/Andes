//
//  String+Extension.swift
//  Smart care bedside display system
//
//  Created by imac-3570 on 2023/10/6.
//

import Foundation
import CryptoSwift

extension String {
    func aesDecrypt(key: String, iv: String) -> String? {
        var result: String?
        do {
            // 使用Base64的解碼方式將字串解碼後再轉换Data
            let data = self
            
            // 用AES方式將Data解密
            let aesDec: AES = try AES(key: key, iv: iv, padding: .noPadding)
            let dec = try aesDec.decrypt(data.bytes)
            print(dec)
            // 用UTF8的編碼方式將解完密的Data轉回字串
            let desData: Data = Data(bytes: dec, count: dec.count)
            print(desData)
            result = String(data: desData, encoding: .utf8)!
        } catch {
            print("\(error)")
        }
        
        return result
    }
}
