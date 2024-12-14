//
//  MainViewController.swift
//  TestJOSE
//
//  Created by imac-3700 on 2024/6/26.
//

import UIKit
//import JOSESwift
import CryptoKit
import CryptoSwift
import Security

import JSONWebEncryption
import JSONWebSignature
import JSONWebAlgorithms
import JSONWebKey
import JSONWebToken


struct ResponseException: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

class AIMapViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
//    let payload = """
//eyJzZWNyZXQiOiJCeGQ0LVBfRlFNODBqNlp4N1hnekRGUXl2WVpKLXRCX3F0bE9Zbm5RWFRRTzluZEtHX2t6QlJGeWR3QXRKeFViRHR4RUl4S1BieEZ3VXJoTk1RRUs3TFFwOGV3RzZJRDY4eUtZcHQ1TXM5RDNHclVKajk1RTVpT3RsdkhzSnpLbnZDcDkyY3NfRl9GWHpvNll6MUxLUzJ3TUQxSmRCenlhYXAwZ0NWMzI0MzNBS295RHVOZlJNSzIzcThhem43SHgzci1jS3B3eVBWSWY2V3drV1piZlc2bmFxOUxnTmZBcjI2UFJ0NlR3WDlOVTVVMVljdUJxaHRINlJsMWNDcmtJT0lGd2k1d2pqRks0RV9FYm5VRnlzT2pMaXd1SVJBeTFRMFFUV2dJZWxXR0JZZnBhQlZKOVVwSk93Q3ZfUmZlX1JiQWVRNHV5dHVEcmNPMUNqdVpqWmciLCJlbmMiOiJBMjU2R0NNIiwidGFnIjoiNnd3ZGM3SkN6M2hfZW4zdGpaYlFaZyIsImFsZyI6IkEyNTZHQ01LVyIsIml2IjoiWXpDTll2bEFHQmFFMTZDbCJ9.g45PGwkN-1S3Gc19wKIABg7_1McpnuG6o5-CPA1jQ4M.UUTgZ2fhYIiqu70l.FeCLWtzKfKc5Kcfrqg9aY0_l-oSSDQCRrkkryY5r3I8AttvwBkfGI5FGdUcrWtkE8X9EKn0XMy0ti4ZVFPY0XNH8DsfA2wSF71OjtZAQH05vtO54-eSyd4UFnO1WkmJbcka3qw4PHueX5S_OLYF9gjE4rWGp_eIgcHvRUcONg2mbiHTNhleFm1F_QJgVGgEO7RhciHiM7ybxiXzdPDKAsp3iA7A33NiBWJqC-B1p_wSJGbVwyRtRBXs0BfSKww7FIjINqhsjV5SVKOHeRuM.ih-7ZnuLxzJuK9v9gC0UKA
//"""
    let payload = """
eyJhbGciOiJBMjU2R0NNS1ciLCJlbmMiOiJBMjU2R0NNIiwiaXYiOiIwSXNma3dVclhndWtYMnFvIiwic2VjcmV0IjoiZnU2M3BZS2tLQVJhWW9NQ18zTl9rQUVNZkNiNmpNN2VoQ3Y0RXdfU2xOUndyU2Q1QzBFMnJIZTQ0LUhESlpiYnM2WmZ2Q1dSbXA4aGZub082d3FuN2lnelM3enRRZVI2OWtyeldQdm1oNzI3S09aMW0xZUdGNEpBVTQwejdxbGVMUmstU3JQT2w2X1R5NVYxblRwYzJPMVhiN0J2N2lPOHA0WnJ5bTdTenYwMmVZQTgyNTBSc05LQVlJREgxS2d5aUpFby13emJQN1FvNG4zTjg2empWbjZEM2xGaWVvQ3lPR2RBU1dJaTlpOUtmV1Nnem5UajNEWXdhODlJNkJVOGRpdzFWMkh2eUk1NU1lZWdsU3RaWU5Wd09peE50ZU5LNU50Rkh6SDNxSklKYlIxRVRxZWZxTmI5REphOGhHSmk1WFkzeW5ySVhod2k3YThiSHllSnp3IiwidGFnIjoiTkp1ZUtTWVBtZ2pHMk1qWGNBc0VndyJ9.Bh0jMrZOTDQnd97l9DA3r3XpSTY_6Gy6qydsUcSqBcU.QKa09wvqTRVSuj8Q.dVratwgd595ndfCfO2ueusazlNONBGuPfXuZO5JTFQWFkoSXdw6zP5tIcJQxAHNMnYoa21VF69UjYTBmzb98mg-mJ3kraXU_f2d7kiy-GiH8wTzIlb4JDorN-WECbnjYKK3AE-JVkEU9SajTGlWaw7roQaHssyiAZo7sgvvNT-NGOlS4D9qU7B1C_6DC-W-x-GBarTO4LeppKCro8OQPSv9lBKmqc4vsT4NW8yfq0ThWmmAbazF47KPzhpZSgsUKEi3m4e_U0jrP1QIxNGQ.d6RkfBsHsGpMOOYl-Pde2Q
"""
    let pin = "839971"
    var jwe: JWE?
    var jwsString: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getJWS()
//        getJWE()
//        api2()
//        getUserData(pin: pin)
        
//        let userJsonStr = nextStep()
        
//        serverBody()
        tokenReponse()
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    
    // MARK: - Function
    
    private func tokenReponse() -> Void {
        let serverJson: [String: Any] = [
            "token-id": "AH69eMR4IFlv6mFjC2jSxSCAAAqnuE8qXVbqfWO3TM0D6cFXd_8my6xDuPbqw3DVUmFqAZ6mNOTBLADbYP4mlQ",
            "token-key": [
                "alg":"ECDH-ES",
                "crv": "P-256",
                "kid": "1",
                "kty": "EC",
                "x": "p7rSRyTOtmGo-158O-PzPWZRCFVO0b0EU6sjo0z8BWc",
                "y": "EQsdCM6dxjiJdiu7zvlKauskiUA2HZy_UcUiPn4PXJ0"
            ]
        ]
        let tokenid = serverJson["token-id"]
        let tokenkey = serverJson["token-key"]
        let timestamp = Int(Date().timeIntervalSince1970)
        let jwtclaims: [String: Any] = [
            "token-id": tokenid!,
            "exp": timestamp + 60,
            "iat": timestamp,
            "user": "apex240819-uqqj-091905-s68v"
        ]
        
        let key = P256.Signing.PrivateKey()
     

        let jwt = try! JWT.signed(
            payload: jwtclaims.description.tryToData(),
            protectedHeader: DefaultJWSHeaderImpl(algorithm: .EdDSA,keyID: "2"),
            key: key
        )
      
        let jwtArray = jwt.jwtString.components(separatedBy: ".")
  
        let jwtData = try! JSONSerialization.data(withJSONObject: jwtclaims, options: [])
        let jwtClaimStr = jwtData.base64URLEncodedString()

        let jwtPayload = jwtArray[0] + "." + jwtClaimStr + "." + jwtArray[2]
 

        let jweHeader: [String: Any] = [
            "epk": [
                "kty": "EC",
                "crv": "P-256",
                "x": "RM4s_HpyAYmIFqwBbgLNxwJwFr_BUqINoDep6OHDgEk",
                "y": "DFGIDvfCdZk6LQIYGSlfe-92hXjaApw2HDN4n715wGo"
            ],
            "token-id": "AH69eMR4IFlv6mFjC2jSxSCAAAqnuE8qXVbqfWO3TM0D6cFXd_8my6xDuPbqw3DVUmFqAZ6mNOTBLADbYP4mlQ",
            "enc": "A256GCM",
            "user": "apex240524-oqut-071514-jzh9",
            "alg": "ECDH-ES"
        ]
        let jweHeaderData = try! JSONSerialization.data(withJSONObject: jweHeader, options: [])
        
        let serverJWK = JWK(keyType: .ellipticCurve,
                                      algorithm: "ECDH-ES",
                                      keyID: "1",
                                      curve: .p256,
                            x: base64URLDecode("p7rSRyTOtmGo-158O-PzPWZRCFVO0b0EU6sjo0z8BWc".base64ToBase64url()),
                            y: base64URLDecode("EQsdCM6dxjiJdiu7zvlKauskiUA2HZy_UcUiPn4PXJ0".base64ToBase64url())).jwk
        
        var protectHeader = DefaultJWEHeaderImpl()
        protectHeader.encodingAlgorithm = .a256GCM
        protectHeader.keyManagementAlgorithm = .ecdhES
        print(protectHeader)
//        protectHeader.jwk = serverJWK.jwk
        
        let jwepayload: [String:Any] = [
            "token" : jwtPayload
        ]
        let jwepayloaddata = try! JSONSerialization.data(withJSONObject: jwepayload,options: [])
        let jwe = try! JWE(payload: jwepayloaddata, protectedHeader: protectHeader, recipientKey: serverJWK)
        
        print("jwetest",jwe.compactSerialization())

    }
    
    
//    private func serverBody() -> Void {
//
//            /// 1. 產生隨機的暫時加密金鑰
//            let encryptPrivateKey = P256.KeyAgreement.PrivateKey()
//
//            let encryptPublicKeyData = encryptPrivateKey.publicKey.rawRepresentation
//            
//            let signPrivateKey = Curve25519.Signing.PrivateKey()
//            
//            let signPublicKeyData = signPrivateKey.publicKey.rawRepresentation
//            
//            let encryptPrivateJwk = JWK(keyType: .ellipticCurve,
//                                 algorithm: "ECDH-ES",
//                                 keyID: "1",
//                                 curve: .p256,
//                                 x: encryptPrivateKey.jwkRepresentation.x,
//                                 y: encryptPrivateKey.jwkRepresentation.y,
//                                 d: encryptPrivateKey.jwkRepresentation.d)
//                    
//            let encryptPublicJwk = JWK(keyType: .ellipticCurve,
//                                 algorithm: "ECDH-ES",
//                                 keyID: "1",
//                                 curve: .p256,
//                                 x: encryptPrivateKey.publicKey.jwkRepresentation.x,
//                                 y: encryptPrivateKey.publicKey.jwkRepresentation.y)
//            
//                    
//            let signKeyDict: [String : Any] = [
//                "kty": "OKP",
//                "use": "sig",
//                "crv": "Ed25519",
//                "kid": "2",
//                "x": signPrivateKey.jwk.x?.base64URLEncodedString() ?? ""
//            ]
//            
//            /// 2. user-request payload 訊息準備好
//            let payloadJson: [String : Any] = [
//                "action" : "phantom-post",
//                "sign-key" : signKeyDict,
//                "dest-id" : ""
//            ]
//                    
//            let base64urlString = "COUq8P2H_meQ1tN9ruFmA9Vvx-o92eew2GEQgh6EvFQ".base64urlToBase64()
//            let data = base64URLDecode(base64urlString)
//            
//            let base64urlString2 = "UE1nvvgEaxqrWqi4koO5FH8FthB5pySaH75nRq1VzDU".base64ToBase64url()
//            let data2 = base64URLDecode(base64urlString2)
//                    
//            let serverJWK = JWK(keyType: .ellipticCurve,
//                                algorithm: "ECDH-ES",
//                                keyID: "1",
//                                curve: .p256,
//                                x: data,
//                                y: data2).jwk
//            
//            let serverKeyDict: [String : Any] = [
//                "alg" : "ECDH-ES",
//                "crv" : "P-256",
//                "kid" : "1",
//                "kty" : "EC",
//                "x" : "COUq8P2H_meQ1tN9ruFmA9Vvx-o92eew2GEQgh6EvFQ",
//                "y" : "UE1nvvgEaxqrWqi4koO5FH8FthB5pySaH75nRq1VzDU"
//            ]
//            let serverKeyData = try! JSONSerialization.data(withJSONObject: serverKeyDict, options: [])
//            
//            let payloadData = try! JSONSerialization.data(withJSONObject: payloadJson, options: [])
//        
//            /// 3. 建立好 JWE Protected Header
//            var protectHeader = DefaultJWEHeaderImpl()
//            protectHeader.keyManagementAlgorithm = .ecdhES
//            protectHeader.encodingAlgorithm = .a256GCM
//            protectHeader.jwk = encryptPublicJwk.jwk
//                    
//            let jwe = try! JWE(payload: payloadData,
//                               protectedHeader: protectHeader,
//                               recipientKey: serverJWK)
//            
//            let jweArray = jwe.compactSerialization().components(separatedBy: ".")
//            let jweHeader = jweArray[0]
//            let jweHeaderDecodedData = base64URLDecode(jweHeader)!
//            let jweHeaderDict = try! JSONSerialization.jsonObject(with: jweHeaderDecodedData, options: []) as! [String: Any]
//
//            print("=======")
//            print(jweHeaderDict)
//            
//            let publicJwkKey = encryptPrivateKey.publicKey.jwk
//            
//            var publicDict: [String : Any] = [:]
//            
//            if let jwk = jweHeaderDict["jwk"] as? [String: Any] {
//                publicDict = [
//                    "kty": jwk["kty"] ?? "",
//                    "use": "enc",
//                    "crv": jwk["crv"] ?? "",
//                    "kid": jwk["kid"] ?? "",
//                    "x": jwk["x"] ?? "",
//                    "y": jwk["y"] ?? ""
//                ]
//                print(jwk)
//            }
//           
//            /// Custom Header is done
//            var cusHeader: [String : Any?] = [
//                "epk": jweHeaderDict["epk"]!,
//                "enc": jweHeaderDict["enc"]!,
//                "public": publicDict,
//                "user":"apex240819-uqqj-091905-s68v",
//                "alg": jweHeaderDict["alg"]!,
//            ]
//        print(cusHeader)
//            let customHeaderJsonData = try! JSONSerialization.data(withJSONObject: cusHeader, options: [])
//            
//            print(String(data: customHeaderJsonData, encoding: .utf8) ?? "")
//            let customHeaderData = base64UrlEncode(data: customHeaderJsonData)
//            let customHeaderStr = String(data: customHeaderData, encoding: .utf8) ?? ""
//            
//            let jweFlattened: [String : Any] = [
//                "ciphertext": jweArray[3],
//                "protected": customHeaderStr,
//                "tag": jweArray[4],
//                "iv": jweArray[2]
//            ]
//            
//            let jweData = try! JSONSerialization.data(withJSONObject: jweFlattened, options: [])
//            let jweFlattenStr = String(data: jweData, encoding: .utf8) ?? ""
//            
//            print("jweFlattenStr", jweFlattenStr)
//            
//    //        let decrypt = try! jwe.decrypt(recipientKey: serverJWK)
//    //
//    //        print("decrypt: ", String(data: decrypt, encoding: .utf8) ?? "")
//            
//    //        return jweData
//        }
    
//    func nextStep() -> String {
//        
//        let userStr = getUserData(pin: pin)
//        if let data = userStr.data(using: .utf8) {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                if let dictionary = json as? [String: Any],
//                   let user = dictionary["user"] as? String,
//                    let serverPublic = dictionary["serverPublic"] as? [String : String] {
//                    
//                    var serverPublicJSON: [String: Any] = [:]
//                    for (key, value) in serverPublic {
//                        if key is String, value is Any {
//                            serverPublicJSON[key] = value
//                        } else {
//                            throw ResponseException("Invalid Server Public")
//                        }
//                    }
//                    
//                    let jsonData = try? JSONSerialization.data(withJSONObject: serverPublicJSON, options: [])
//                    let jsonString = String(data: jsonData ?? Data(), encoding: .utf8)
//                    print("JsonString:  \(jsonString ?? "")")
//                    
//                    return jsonString ?? ""
//                } else {
//                    throw ResponseException("Invalid User")
//                }
//            } catch {
//                print("error \(error.localizedDescription)")
//            }
//        }
//        return ""
//    }
//    
//    
//    func getUserData(pin: String) -> String {
//        let (secretData, secretHex) = secretToHex(payload: payload)
//        // secretHex = 07177...
//        print("secretHex: ", secretHex)
//        
//        var decryptKey = getDecryptKey(encryptSeed: secretData, pin: pin)
//        // decryptKey to hex = F342E...
//        print("decryptKey to hex: ", decryptKey.toHexString())
//        
//        let keyJWK = JWK(keyType: .octetSequence, key: decryptKey)
//
//        do {
//            let decryptedData = try jwe?.decrypt(sharedKey: keyJWK)
//            if let decryptedString = String(data: decryptedData!, encoding: .utf8) {
//                print("解密後的資料: \(decryptedString)")
//                return decryptedString
//            } else {
//                print("無法將解密後的資料轉換為字串")
//            }
//        } catch {
//            print("解密失敗: \(error)")
//            print("操作者輸入之 PIN 不正確")
//        }
//        return ""
//    }
//    
//    func secretToHex(payload: String) -> (Data, String) {
//        
//        jwe = try! JWE(compactString: payload)
//        let compactString: String = String(data: jwe!.protectedHeaderData, encoding: .utf8)!
//        print(compactString)
//        if let data = compactString.data(using: .utf8) {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                if let dictionary = json as? [String: Any],
//                   let secret = dictionary["secret"] as? String {
//                    let data = secret.data(using: .utf8)
//                    print("Secret base64url", secret)
//                    let base64String = secret.base64urlToBase64()
//                    if let data = Data(base64Encoded: base64String) {
//                        let hexString = data.toHexString()
//                        return (data, hexString)
//                    } else {
//                        print("無法解碼Base64字串。")
//                    }
//                }
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//        return (Data(), "")
//    }
//    
//    func getDecryptKey(encryptSeed: Data, pin: String) -> Data {
//        var combinedData = Data()
//        combinedData.append(encryptSeed)
//        combinedData.append(Data(pin.utf8))
//        combinedData.append(encryptSeed)
//        return combinedData.sha256()
//    }
}

// MARK: - Extensions

extension AIMapViewController {
    
    // 將Base64URL編碼字串還原為Data
    func base64URLDecode(_ base64URLString: String) -> Data? {
        var base64 = base64URLString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // 根據Base64規格補上缺失的`=`號
        switch base64.count % 4 {
        case 2: base64 += "=="
        case 3: base64 += "="
        default: break
        }
        
        return Data(base64Encoded: base64)
    }
    
    func base64UrlEncode(data: Data) -> Data {
        let base64String = data.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return base64String.data(using: .utf8)!
    }
    
    func base64Encoding(plainString: String) -> String {
        let plainData = plainString.data(using: .utf8)
        let base64String = plainData?.base64EncodedString()
        return base64String!
    }
    
    func aes256Decrypt(cipherText data: Data, privateKey key: String, iv: String) -> Data? {
        do {
            let aes = try AES(key: key, iv: iv, padding: .pkcs7) // 建立 AES Cryptor 實例
            let decryptedBytes = try aes.decrypt(data.bytes)
            let decryptedData = Data(decryptedBytes)
            return decryptedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getJWS(){
        // 生成EdDSA簽名密鑰對
        let signPrivateKey = Curve25519.Signing.PrivateKey()

        // 生成ECDH密鑰交換密鑰對
        let encryptPrivateKey = P256.KeyAgreement.PrivateKey()

        // 取得簽名公鑰
        let signPublicKeyData = signPrivateKey.publicKey.rawRepresentation

        let encryptPublicKeyData = encryptPrivateKey.publicKey.rawRepresentation

        // 將公鑰轉換為JWK格式
        var signPublicJWK = JWK(keyType: .octetKeyPair,
                                curve: .ed25519,
                                x: base64UrlEncode(data: signPublicKeyData))
                
        // 將公鑰轉換為JWK格式
        var encryptPublicJWK = JWK(keyType: .ellipticCurve,
                                   curve: .p256,
                                   x: base64UrlEncode(data: encryptPublicKeyData.prefix(32)),
                                   y: base64UrlEncode(data: encryptPublicKeyData.dropFirst(32)),
                                   d: base64UrlEncode(data: encryptPrivateKey.rawRepresentation))
        
        // 輸出 JWK
        let signPublicJWKData = try! JSONEncoder().encode(signPublicJWK)
        let signPublicJWKString = String(data: signPublicJWKData, encoding: .utf8)

        let encryptPublicJWKData = try! JSONEncoder().encode(encryptPublicJWK)
        let encryptPublicJWKString = String(data: encryptPublicJWKData, encoding: .utf8)
        
        let userId = "john@example.com"

        // 將 JWK 轉換為 JSON 字符串
        guard let signPublicJWKString = signPublicJWKString,
              let encryptPublicJWKString = encryptPublicJWKString else {
            print("Failed to encode JWK strings")
            return
        }

        // 構建最終的 JSON 對象
        let onboardingPaload: [String: Any] = [
            "user": userId,
            "verify": signPublicJWKString,
            "secret": encryptPublicJWKString
        ]

        // 輸出 JSONString
        if let jsonData = try? JSONSerialization.data(withJSONObject: onboardingPaload, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
//            print("==================")
            print("jsonString: \(jsonString)")
//            print("==================")
        } else {
            print("Failed to encode JSON object")
        }

        // 將 JSONString 轉成 Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: onboardingPaload, options: []) else {
            print("Failed to encode JSON object")
            return
        }
        
        let header = DefaultJWSHeaderImpl(algorithm: .ES256)
        let jws = try! JWS(
            payload: jsonData,
            protectedHeader: header,
            key: signPrivateKey
        )

//        print("JWS: \(jws.compactSerialization)")
        jwsString = jws.compactSerialization
    }
    
    func getJWE() {
        
        // 生成EdDSA簽名密鑰對
        let signPrivateKey = Curve25519.Signing.PrivateKey()

        // 生成ECDH密鑰交換密鑰對
        let encryptPrivateKey = P256.KeyAgreement.PrivateKey()

        let encryptPublicKeyData = encryptPrivateKey.publicKey.rawRepresentation
        
        // 將公鑰轉換為JWK格式
        var encryptPublicJWK = JWK(keyType: .ellipticCurve,
                                   curve: .p256,
                                   x: base64UrlEncode(data: encryptPublicKeyData.prefix(32)),
                                   y: base64UrlEncode(data: encryptPublicKeyData.dropFirst(32)),
                                   d: base64UrlEncode(data: encryptPrivateKey.rawRepresentation)
        )

        
        var header = DefaultJWEHeaderImpl()
        header.keyManagementAlgorithm = .a256GCMKW
        header.encodingAlgorithm = .a256GCM
        
//        var userPayload = "test".data(using: .utf8)!
//
        
        
        let payload = "Hello world".data(using: .utf8)!
        let jwe = try! JWE(payload: payload,
                           protectedHeader: header,
                           recipientKey: encryptPublicJWK)
//        let serialization = try! JWE(payload: payload,
//                                    keyManagementAlg: .ecdhES,
//                                    encryptionAlgorithm: .a256GCM,
//                                     recipientKey: encryptPrivateKey.publicKey
//        )
        let decrypted = try! jwe.decrypt(recipientKey: encryptPublicJWK)
        print(String(data: decrypted, encoding: .utf8)!)
    }
    
    func api2() {
        // 生成ECDH密鑰交換密鑰對
        let encryptPrivateKey = P256.KeyAgreement.PrivateKey()

        let encryptPublicKeyData = encryptPrivateKey.publicKey.rawRepresentation
        
        // 將公鑰轉換為JWK格式
        var encryptPublicJWK = JWK(keyType: .ellipticCurve,
                                   curve: .p256,
                                   x: base64UrlEncode(data: encryptPublicKeyData.prefix(32)),
                                   y: base64UrlEncode(data: encryptPublicKeyData.dropFirst(32)),
                                   d: base64UrlEncode(data: encryptPrivateKey.rawRepresentation)
        )

        
        var header = DefaultJWEHeaderImpl()
//        header.keyManagementAlgorithm = .ecdhES
//        header.encodingAlgorithm = .a256GCM
        
        var userPayload = "test".data(using: .utf8)!
        
        let jwe = try! JWE(payload: userPayload,
                           protectedHeader: header,
                           recipientKey: encryptPublicJWK)
        
        let decrypted = try! jwe.decrypt(recipientKey: encryptPublicJWK)
        print(String(data: decrypted, encoding: .utf8)!)
    }
    
  
}
extension Data {
    func base64URLEncodedString() -> String {
       let s = self.base64EncodedString()
       return s
           .replacingOccurrences(of: "=", with: "")
           .replacingOccurrences(of: "+", with: "-")
           .replacingOccurrences(of: "/", with: "_")
   }
}
extension String {
    func base64urlToBase64() -> String {
            var base64 = self
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            if base64.count % 4 != 0 {
                base64.append(String(repeating: "=", count: 4 - base64.count % 4))
            }
            return base64
        }
        
    func base64ToBase64url() -> String {
        var base64url = self
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
        if base64url.count % 4 != 0 {
            base64url.append(String(repeating: "=", count: 4 - base64url.count % 4))
        }
        return base64url
    }
}
