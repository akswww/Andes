

import UIKit
import SwiftyRSA
import CryptoSwift
import CryptoKit

class EncrypViewController: UIViewController {
    
    let enkey = "MIICWwIBAAKBgQC5RIsJTl4clHRaHcUfpELHx6iAxc+S+Z8kAQhfc1uP8FzcFH+n sIMushjeBFmzvGezahDk+mZ3WwwW141MpsXIrCwUYxcTwGSYsQ5/9mQLfNw2nhCs vFTonekOShA9z5N+uFuByJvUM9RvnuBFy6knfRzQsh8LvfEuE0SRMYclMQIBAwKB gHuDB1uJlBMNoua+g2ptgdqFGwCD37dRFMKrWupM57VK6JK4VRp1rMnMEJQC5nfS 78zxYJim7vo8srnlCN3Eg9n5xf1WJFilNelObcW7Tjz/pvQbrxaSlKarpHAdxsam 2kRz0CcSwAJP8aQdA0jvpIh0KmkTjQBQHPbCXpVIts7DAkEA72M+5wd9QP3RBj/8 jX2TciKna+7o74ianNzKQZT2h530iUIYbzLJKhvIpC5Gw90z7XmWTI7AxgymER+f JksNJwJBAMYf2XrZEYeV6bUp2s/xHIs/IQibIfDtU/+Vm9vRHU2uI4FhLr1JB5HO MM8tEaBVJuFjnMg8yn+5Fd6XEh4p4ecCQQCfl39Er6jV/otZf/2zqQz2wcTyn0X1 BbxokzGBDfmvvqMGLBBKIdtxZ9sYHtnX6M1I+7mIXysusxlgv79u3LNvAkEAhBU7 pzthBQ6bzhvnNUtoXNTAsGdr9fONVQ5n5+C+M8ltAOt0fjCvtol133NhFY4Z65e9 2tMxqntj6boMFBvr7wJAYP7TQzJAfvc5hbny8NM6zS7bT2XLT0D6tmmONPI7g3+U TNLPkRJj5/NIC+E6r8ARJ6Urykd1iCjSQCrKMADlfA=="
    
    let enText = hexStringToData("4505B3493F353447CED3E7F0071DD6EE749842DD216D4C19E995283B20C1FD96641493A25649A87EF56E34491D29EE4525239A6E798FD0546B480E412289734AB903F7E38EEC734A7A19CAC55653A3B6327D384E62F3EB7BB7CACD7800C1CCF11E89043D697311D263C80E8E3355D3AA922E65527FF5CB8459ECBE7EF9B0DAF5704B707DBBD7A5B8FE3AC9915F6A9EA4916B78C9326D5FC5D8EFB1E61E2B84E4")

    let enRsa = "4505B3493F353447CED3E7F0071DD6EE749842DD216D4C19E995283B20C1FD96641493A25649A87EF56E34491D29EE4525239A6E798FD0546B480E412289734AB903F7E38EEC734A7A19CAC55653A3B6327D384E62F3EB7BB7CACD7800C1CCF11E89043D697311D263C80E8E3355D3AA922E65527FF5CB8459ECBE7EF9B0DAF5704B707DBBD7A5B8FE3AC9915F6A9EA4916B78C9326D5FC5D8EFB1E61E2B84E4".data(using: .utf8)
    var binaryString :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decryptMessage()
        let encry_symmetricKeyLength = 128 // 128 bytes
        let ivLength = 12 // 12 bytes
        let tagLength = 16 // 16 bytes

        let symmetricKeyRange = 0..<encry_symmetricKeyLength
        let ciphertextRange = encry_symmetricKeyLength..<(enText!.count - ivLength - tagLength)
        let ivRange = ciphertextRange.upperBound..<(ciphertextRange.upperBound + ivLength)
        let tagRange = ivRange.upperBound..<enText!.count

        let rsa_symmetricKey = enText!.subdata(in: symmetricKeyRange)
        let ciphertext = enText!.subdata(in: ciphertextRange)
        let iv = enText!.subdata(in: ivRange)
        let tag = enText!.subdata(in: tagRange)

        print("Symmetric Key: \(rsa_symmetricKey)")
        print("Ciphertext: \(ciphertext)")
        print("IV: \(iv)")
        print("Tag: \(tag)")

//        let /*decypeStr = ciphertext.description.aesDecrypt(key:   hexStringToData("C6FE8F239B459CB8942E09D652CBB291AA67EDEE68346911B3F0CCA14F041125"), iv: "BBD7A5B8FE3AC9915F6A9EA4")*/
        
        
        do {
            let privateKey = try PrivateKey(pemEncoded: enkey)

            let encryptedDec = EncryptedMessage(data: rsa_symmetricKey)
            
            if let clearMessage = try? encryptedDec.decrypted(with: privateKey, padding: .PKCS1) {
                let decryptedData = clearMessage.data
                print("Decryption successful: \(decryptedData.toHexString())")
                
//                let authData = "8C50FDE777514AA21CE54A3739AAA798".data(using: .utf8)!
                
                // 用下面轉bin
                let hexString = "8C50FDE777514AA21CE54A3739AAA798"
                
               
                if let finalDecryptedData = aesGcmDecrypt(ciphertext: ciphertext, key: EncrypViewController.hexStringToData(decryptedData.toHexString())!, iv: iv, tag: tag, authData: EncrypViewController.hexStringToData(hexString)!) {
                    print("Decryption successful: \(finalDecryptedData)")
                   print( String(data: finalDecryptedData, encoding: .utf8))
                } else {
                    print("Symmetric Key: \(rsa_symmetricKey)")
                    print("Ciphertext: \(ciphertext)")
                    print("IV: \(iv)")
                    print("Tag: \(tag)")
                    print("Decryption failed")
                }
            } else {
                print("Decryption failed1")
            }
        } catch {
            print("Decryption failed: \(error)")
        }
        
       
    }
    
    
    func decrypt(
        encryptedData: Data,
        key: Data,
        iv: Data,
        tag: Data
    ) throws -> Data {
        let symmetricKey = SymmetricKey(data: key)
        let nonce = try AES.GCM.Nonce(data: iv)
        
        let sealedBox = try AES.GCM.SealedBox(
            nonce: nonce,
            ciphertext: encryptedData,
            tag: tag
        )
        
        return try AES.GCM.open(sealedBox, using: symmetricKey)
    }
    
    func aesGcmDecrypt(ciphertext: Data, key: Data, iv: Data, tag: Data, authData: Data) -> Data? {
        let symmetricKey = SymmetricKey(data: key)
        let sealedBox = try? AES.GCM.SealedBox(nonce: AES.GCM.Nonce(data: iv), ciphertext: ciphertext, tag: tag)
        guard let box = sealedBox else {
            return nil
        }
        
        let decryptedData = try? AES.GCM.open(box, using: symmetricKey, authenticating: authData)
        return decryptedData
    }
    
    static  func hexStringToData(_ hex: String) -> Data? {
        var data = Data()
        var tempHex = hex

        // 移除所有空白和換行
        tempHex = tempHex.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)

        // 確保字串長度為偶數
        if tempHex.count % 2 != 0 {
            tempHex = "0" + tempHex
        }

        var index = tempHex.startIndex
        while index < tempHex.endIndex {
            let byteString = tempHex[index..<tempHex.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                // 無效的十六進制字元
                return nil
            }
            index = tempHex.index(index, offsetBy: 2)
        }
        return data
    }
    
    func decryptMessage() {
        // 將十六進制字串轉換為 Data
        let encryptedHex = "4505B3493F353447CED3E7F0071DD6EE749842DD216D4C19E995283B20C1FD96641493A25649A87EF56E34491D29EE4525239A6E798FD0546B480E412289734AB903F7E38EEC734A7A19CAC55653A3B6327D384E62F3EB7BB7CACD7800C1CCF11E89043D697311D263C80E8E3355D3AA922E65527FF5CB8459ECBE7EF9B0DAF5".data(using: .utf8)
        
        
        let encry_symmetricKeyLength = 128 // 128 bytes
        let ivLength = 12 // 12 bytes
        let tagLength = 16 // 16 bytes

        let symmetricKeyRange = 0..<encry_symmetricKeyLength
        let ciphertextRange = encry_symmetricKeyLength..<(encryptedHex!.count - ivLength - tagLength)
        let ivRange = ciphertextRange.upperBound..<(ciphertextRange.upperBound + ivLength)
        let tagRange = ivRange.upperBound..<encryptedHex!.count

        let rsa_symmetricKey = encryptedHex!.subdata(in: symmetricKeyRange)
        let ciphertext = encryptedHex!.subdata(in: ciphertextRange)
        let iv = encryptedHex!.subdata(in: ivRange)
        let tag = encryptedHex!.subdata(in: tagRange)
        
        let keyHex = "C6FE8F239B459CB8942E09D652CBB291AA67EDEE68346911B3F0CCA14F041125"
        let ivHex = "BBD7A5B8FE3AC9915F6A9EA4"
        let tagHex = "916B78C9326D5FC5D8EFB1E61E2B84E4"
        
        guard let encrypted = Data(hexString: String(data: ciphertext, encoding: .utf8)!),
              let key = Data(hexString: keyHex),
              let iv = Data(hexString: ivHex),
              let tag = Data(hexString: tagHex) else {
            print("數據轉換失敗")
            return
        }
        
        
        
        do {
            let decryptedData = try decrypt(
                encryptedData: encrypted,
                key: key,
                iv: iv,
                tag: tag
            )
            
            if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                print("解密結果：", decryptedString)
            }
        } catch {
            print("解密失敗：", error)
        }
    }
    
}


extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var i = hexString.startIndex
        for _ in 0..<len {
            let j = hexString.index(i, offsetBy: 2)
            let bytes = hexString[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
            i = j
        }
        self = data
    }
    
    func toHexString() -> String {
          return self.map { String(format: "%02x", $0) }.joined()
      }
  
}
