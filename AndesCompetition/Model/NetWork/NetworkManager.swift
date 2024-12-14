//
//  NetworkManager.swift
//  Smart care bedside display system
//
//  Created by imac-3570 on 2023/10/2.
//

import Foundation

class NetworkManager: NSObject, URLSessionDelegate {
    
    static var shared = NetworkManager()
    
    public func requestData<E, D>(method: HTTPMethod,
                                  path: ApiPathConstants,
                                  parameters: E) async throws -> D where E: Encodable, D: Decodable {
        let urlRequest = handleHTTPMethod(method, path, parameters)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = (response as? HTTPURLResponse) else {
                throw RequestError.invalidResponse
            }
            let statusCode = response.statusCode
            guard (200 ... 299).contains(statusCode) else {
                switch statusCode {
                case 400:
                    throw RequestError.badRequest
                case 401:
                    throw RequestError.authorizationError
                case 404:
                    throw RequestError.notFound
                case 500:
                    throw RequestError.internalError
                case 502:
                    throw RequestError.badGateway
                case 503:
                    throw RequestError.serverUnavailable
                default:
                    throw RequestError.invalidResponse
                }
            }
            do {
                let result = try JSONDecoder().decode(D.self, from: data)
                
                #if DEBUG
                printNeworkProgress(urlRequest, parameters, result)
                #endif
                
                return result
            } catch {
                throw RequestError.jsonDecodeFailed(error as! DecodingError)
            }
        } catch {
            print(error.localizedDescription)
            throw RequestError.unknownError(error)
        }
    }
    
    private func requestWithURL(urlString: String, parameters: [String : String]?) -> URL? {
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        urlComponents.queryItems = []
        parameters?.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return urlComponents.url
    }
    
    private func handleHTTPMethod<E: Encodable>(_ method: HTTPMethod,
                                                _ path: ApiPathConstants,
                                                _ parameters: E?) -> URLRequest {
        UserPreferences.shared.networkPath = "192.168.1.153:5031/"
        print(UserPreferences.shared.networkPath)
        let baseURL = NetworkConstants.httpBaseUrl + UserPreferences.shared.networkPath
        let url = URL(string: baseURL + path.rawValue)!
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let httpType = NetworkConstants.ContentType.json.rawValue
        print( UserPreferences.shared.token)
        urlRequest.allHTTPHeaderFields = [
            NetworkConstants.HttpHeaderField.authentication.rawValue : UserPreferences.shared.token,
            NetworkConstants.HttpHeaderField.contentType.rawValue : httpType]
        urlRequest.httpMethod = method.rawValue
        
        let dict1 = try? parameters.asDictionary()
        
        switch method {
        case .get:
            let parameters = dict1 as? [String : String]
            urlRequest.url = requestWithURL(urlString: urlRequest.url?.absoluteString ?? "", parameters: parameters ?? [:])
        default:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict1 ?? [:], options: .prettyPrinted)
        }
        return urlRequest
    }
    
    private func printNeworkProgress<E: Encodable, D: Decodable>(_ urlRequest: URLRequest, _ parameters: E, _ results: D) {
        #if DEBUG
        print("=======================================")
        print("- URL: \(urlRequest.url?.absoluteString ?? "")")
        print("- Header: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("---------------Request-----------------")
        print(parameters)
        print("---------------Response----------------")
        print(results)
        print("=======================================")
        #endif
    }
    
    /**
         Requests credentials from the delegate in response to a session-level authentication request from the remote server.
         从委托中获得请求证书 响应来自远程服务器的会话级身份验证请求
         */

        //URLAuthenticationChallenge： 授权质问
        //URLSession.AuthChallengeDisposition：响应身份验证
        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

            /**
             protectionSpace：从保护空间对象提供关于身份验证请求的附加信息，
             并告诉你身份验证方法 采用您提供用户的证书还是验证服务器提供的证书
             */
            if challenge.protectionSpace.authenticationMethod
                == (NSURLAuthenticationMethodServerTrust) {

                //SecTrust:security Trust 也叫信任对象Trust Object 包含关于信任管理的信息
                //从服务器信任的保护空间返回一个SecTrust
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                //从信任管理链中获取第一个证书
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)

                //SecCertificateCopyData：返回一个DER 编码的 X.509 certificate
                //根据二进制内容提取证书信息
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate!))!
                //本地加载证书
                let cerPath = Bundle.main.path(forResource: "server", ofType: "cer")!
                let cerUrl = URL(fileURLWithPath: cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)

                // 证书校验：这里直接比较本地证书文件内容 和 服务器返回的证书文件内容
                if localCertificateData as Data == remoteCertificateData as! Data {
                    let credential = URLCredential(trust: serverTrust)
                    //尝试继续请求而不提供证书作为验证凭据
                    challenge.sender!.continueWithoutCredential(for: challenge)
                    //尝试使用证书作为验证凭据，建立连接
                    challenge.sender?.use(credential, for: challenge)
                    //回调给服务器，使用该凭证继续连接
                    completionHandler(URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust: challenge.protectionSpace.serverTrust!))
                }else {
                    challenge.sender?.cancel(challenge)
                    // 证书校验不通过
                    completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                }

            }
        }

    
}

//extension NetworkManager: NSObject, URLSessionDelegate {
//    /**
//         Requests credentials from the delegate in response to a session-level authentication request from the remote server.
//         从委托中获得请求证书 响应来自远程服务器的会话级身份验证请求
//         */
//
//        //URLAuthenticationChallenge： 授权质问
//        //URLSession.AuthChallengeDisposition：响应身份验证
//        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//            /**
//             protectionSpace：从保护空间对象提供关于身份验证请求的附加信息，
//             并告诉你身份验证方法 采用您提供用户的证书还是验证服务器提供的证书
//             */
//            if challenge.protectionSpace.authenticationMethod
//                == (NSURLAuthenticationMethodServerTrust) {
//
//                //SecTrust:security Trust 也叫信任对象Trust Object 包含关于信任管理的信息
//                //从服务器信任的保护空间返回一个SecTrust
//                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
//                //从信任管理链中获取第一个证书
//                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
//
//                //SecCertificateCopyData：返回一个DER 编码的 X.509 certificate
//                //根据二进制内容提取证书信息
//                let remoteCertificateData
//                    = CFBridgingRetain(SecCertificateCopyData(certificate!))!
//                //本地加载证书
//                let cerPath = Bundle.main.path(forResource: "server", ofType: "cer")!
//                let cerUrl = URL(fileURLWithPath:cerPath)
//                let localCertificateData = try! Data(contentsOf: cerUrl)
//
//                // 证书校验：这里直接比较本地证书文件内容 和 服务器返回的证书文件内容
//                if localCertificateData as Data == remoteCertificateData as! Data {
//                    let credential = URLCredential(trust: serverTrust)
//                    //尝试继续请求而不提供证书作为验证凭据
//                    challenge.sender!.continueWithoutCredential(for: challenge)
//                    //尝试使用证书作为验证凭据，建立连接
//                    challenge.sender?.use(credential, for: challenge)
//                    //回调给服务器，使用该凭证继续连接
//                    completionHandler(URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust: challenge.protectionSpace.serverTrust!))
//                }else {
//                    challenge.sender?.cancel(challenge)
//                    // 证书校验不通过
//                    completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
//                }
//
//            }
//        }
//}

