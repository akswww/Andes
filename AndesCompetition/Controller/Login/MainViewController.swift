//
//  MainViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/7/1.
//

import UIKit
import MaterialComponents
import LocalAuthentication

class MainViewController: BaseViewController {
    
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var txfAccount: MDCOutlinedTextField!
    @IBOutlet weak var txfPassword: MDCOutlinedTextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnBiology: UIButton!
    let gradient = CAGradientLayer()
    let manager = NetworkManager()
    
    struct EmptyStruct: Codable {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbarGradientColor()
        self.title = "Login"
        setView()
        setuptextFields()
        setLoginView()
        setNavbar()
        checkbiology()
        
        
    }
    
    func setNavbar() {
        let registerButton = UIBarButtonItem(title: "註冊", style: .plain, target: self, action: #selector(showRegistrationAlert))
        navigationItem.rightBarButtonItem = registerButton
    }
    
    func checkbiology() {
        let context = LAContext()
        var error: NSError?
        
        // 檢查是否支持 Face ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 檢查設備是否支持 Face ID 而非 Touch ID
            if context.biometryType == .faceID {
                print("設備支持 Face ID")
            } else {
                print("設備不支持 Face ID，可能只有 Touch ID")
            }
        } else {
            if let error = error {
                print("生物識別不可用：\(error.localizedDescription)")
            }
        }
    }
    
    @objc func showRegistrationAlert() {
        let alertController = UIAlertController(title: "註冊", message: "請輸入用戶名和密碼", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "用戶名"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "密碼"
            textField.isSecureTextEntry = true
        }
        
        let registerAction = UIAlertAction(title: "註冊", style: .default) { _ in
            guard let username = alertController.textFields?[0].text,
                  let password = alertController.textFields?[1].text else { return }
            
            
            print("用戶名: \(username)")
            print("密碼: \(password)")
            
            
            Task {
                let request: LoginRequest = LoginRequest(username: username, password: password)
                let result: BaseReponse = try await self.manager.requestData(method: .post,
                                                                              path: .register,
                                                                              parameters: request)
                if(result.result == 0) {
                    Alert.showAlert(title: "", message: "註冊成功", vc: self, confirmTitle: "確認")
                    Alert.showAlert(title: "", message: "是否啟用生物辨識", vc: self, confirmTitle: "啟動", cancelTitle: "取消",confirmAction: {
                        print("啟動")
                        UserPreferences.shared.account = username
                        UserPreferences.shared.password = password
                        UserPreferences.shared.usebiology = true
                    }) {
                        print("不啟動")
                        UserPreferences.shared.usebiology = false
                    }
                    self.dismiss(animated: true)
                } else  {
                    Alert.showAlert(title: "", message: "註冊失敗", vc: self, confirmTitle: "確認")
                    self.dismiss(animated: true)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(registerAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func setView() {
        gradient.frame = imageBack.bounds
        gradient.colors = [UIColor.ThemeColor?.cgColor as Any,
                           UIColor.TintColor?.cgColor as Any]
        gradient.locations = [1,0]
        imageBack.layer.addSublayer(gradient)
    }
    
    func setuptextFields() {
        txfAccount.label.text = "輸入帳號"
        txfAccount.setOutlineColor(.gray, for: .editing)
        txfAccount.autocorrectionType = .no
        txfAccount.trailingAssistiveLabel.font = UIFont.systemFont(ofSize: 15)
        
        txfPassword.label.text = "輸入密碼"
        txfPassword.setOutlineColor(.gray, for: .editing)
        txfPassword.autocorrectionType = .no
        txfPassword.trailingAssistiveLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    func setLoginView() {
        DispatchQueue.main.async {
            self.btnLogin?.layer.cornerRadius = 10
            self.btnLogin?.layer.borderWidth = 2
            self.btnLogin?.layer.borderColor = UIColor.lightGray.cgColor
            self.btnLogin?.layer.backgroundColor = UIColor.gray.cgColor
            self.btnLogin?.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            self.btnLogin?.tintColor = .white
            self.btnLogin?.semanticContentAttribute = .forceRightToLeft
            
            self.btnBiology?.layer.cornerRadius = 10
            self.btnBiology?.layer.borderWidth = 2
            self.btnBiology?.layer.borderColor = UIColor.lightGray.cgColor
            self.btnBiology?.layer.backgroundColor = UIColor.gray.cgColor
            //            self.btnBiology?.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            self.btnBiology?.tintColor = .white
            self.btnBiology?.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    
    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "使用 Face ID 確認您的身份"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async { [self] in
                    if success {
                        print("身份驗證成功！")
                        let request: LoginRequest = LoginRequest(username: UserPreferences.shared.account, password: UserPreferences.shared.password)
                        Task {
                            let result: LoginReponse = try await self.manager.requestData(method: .post,
                                                                                          path: .login,
                                                                                          parameters: request)
                            if(result.result == 0) {
                                UserPreferences.shared.token = result.data.token
                                let vc = UserInfoViewController()
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                Alert.showAlert(title: "", message: "登入失敗", vc: self, confirmTitle: "確定")
                            }
                        }
                        
                    } else {
                        if let error = error {
                            print("驗證失敗，錯誤：\(error.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            if let error = error {
                print("設備不支持 Face ID，錯誤：\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func doLogin(_ sender: UIButton) {
        let request: LoginRequest = LoginRequest(username: txfAccount.text!, password: txfPassword.text!)
        Task {
            let result: LoginReponse = try await self.manager.requestData(method: .post,
                                                                          path: .login,
                                                                          parameters: request)
            if(result.result == 0) {
                UserPreferences.shared.token = result.data.token
                let vc = UserInfoViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                Alert.showAlert(title: "", message: "登入失敗", vc: self, confirmTitle: "確定")
            }
        }
        
    }
    
    
    @IBAction func biologyLogin(_ sender: Any) {
        if(UserPreferences.shared.usebiology) {
            authenticateWithFaceID()
        } else {
            Alert.showAlert(title: "", message: "尚未開啟生物認證", vc: self, confirmTitle: "確定")
        }
    }
    
}
