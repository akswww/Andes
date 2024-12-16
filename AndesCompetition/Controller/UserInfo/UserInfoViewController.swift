//
//  UserInfoViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/7/28.
//

import UIKit
import Lottie

class UserInfoViewController: BaseViewController {
    
    @IBOutlet weak var InfoTb: UITableView!
    
    @IBOutlet weak var goNextbtn: UIButton!
    
    @IBOutlet weak var animateBackgroundView: UIView!
    
    var name: String?
    
    var tall: Double?
    
    var weight: Double?
    
    var idcard: String?
    
    var birther: String?
    
    var gender: Bool?
    
    var genderStr: String?
    
    let manager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTbview()
        setNavigationbarGradientColor()
        self.title = "用戶資訊"
        setupAnimate()
        self.hideKeyboardWhenTappedAround()
        InfoTb.allowsSelection = true
        setBtn()
        navigationItem.hidesBackButton = true
    }
    
    
    func setupAnimate() {
        let animationView = LottieAnimationView(name: "DotBackgroundAnimate")
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: animateBackgroundView.frame.width, height: animateBackgroundView.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.5)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animateBackgroundView!.addSubview(animationView)
        animationView.play()
    }
    
    func setTbview() {
        InfoTb?.register(UINib(nibName: "UserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: UserInfoTableViewCell.identified)
        InfoTb?.dataSource = self
        InfoTb?.delegate = self
    }
    
    func setBtn() {
        DispatchQueue.main.async {
            self.goNextbtn?.layer.cornerRadius = 10
            self.goNextbtn?.layer.borderWidth = 2
            self.goNextbtn?.layer.borderColor = UIColor.lightGray.cgColor
            self.goNextbtn?.layer.backgroundColor = UIColor.gray.cgColor
            self.goNextbtn?.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            self.goNextbtn?.tintColor = .white
            self.goNextbtn?.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    
    @IBAction func sendInfo(_ sender: UIButton) {
        let request: UserInfoRequest = UserInfoRequest(name: name!,
                                                       height: tall!,
                                                       gender: gender!,
                                                       weight: weight!,
                                                       birthday: birther!,
                                                       national_id: idcard!)
        Task {
            let result: BaseReponse = try await manager.requestData(method: .post, path: .UserInfo, parameters: request)
            if(result.result == 0) {
                let vc = TabbarViewController()
                UserPreferences.shared.name = name!
                UserPreferences.shared.tall = String(tall!)
                UserPreferences.shared.gender = genderStr!
                UserPreferences.shared.birther = birther!
                UserPreferences.shared.idcard = idcard!
                UserPreferences.shared.weight = String(weight!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
    
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InfoTb?.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identified,
                                               for: indexPath) as! UserInfoTableViewCell
        if(indexPath.row == 0) {
            cell.infoLb.text = "姓名"
            cell.InfoText.delegate = self
            cell.InfoText.tag = 0
        } else if (indexPath.row == 1) {
            cell.infoLb.text = "身高"
            cell.InfoText.delegate = self
            cell.InfoText.tag = 1
        } else if (indexPath.row == 2) {
            cell.infoLb.text = "體重"
            cell.InfoText.delegate = self
            cell.InfoText.tag = 2
        } else if (indexPath.row == 3) {
            cell.infoLb.text = "生日"
            cell.InfoText.delegate = self
            cell.InfoText.placeholder = "預設格式1992-11-11"
            cell.InfoText.tag = 3
        } else if (indexPath.row == 4) {
            cell.infoLb.text = "身份證"
            cell.InfoText.delegate = self
            cell.InfoText.tag = 4
        }  else if (indexPath.row == 5) {
            cell.infoLb.text = "性別"
            cell.InfoText.placeholder = ""
            cell.InfoText.isEnabled = false
            cell.InfoText.text = genderStr
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 5) {
            
            Alert.showActionSheet(array: ["男生","女生"], canceltitle: "取消", vc: self) { i in
               
                if(i==0) {
                    self.gender = false
                    self.genderStr = "男生"
                } else {
                    self.gender = true
                    self.genderStr = "女生"
                }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    
    
}

extension UserInfoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if(textField.tag == 0 ) {
            print("姓名", textField.text ?? "")
            name = textField.text
        } else if(textField.tag == 1) {
            print("身高", textField.text ?? "")
            tall = Double(textField.text ?? "")
        } else if (textField.tag == 2) {
            print("體重", textField.text ?? "")
            weight = Double(textField.text ?? "")
        } else if(textField.tag == 3) {
            print("生日", textField.text ?? "")
            birther = textField.text
        } else if(textField.tag == 4) {
            print("身份證" , textField.text ?? "")
            idcard = textField.text
        }
    }
}


extension UserInfoViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


