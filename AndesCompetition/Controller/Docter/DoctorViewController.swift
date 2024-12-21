//
//  DoctorViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/9/10.
//

import UIKit
import Lottie


class DoctorViewController: BaseViewController {
    
    @IBOutlet weak var registerTb: UITableView!
    
    @IBOutlet weak var DocV: UIView!
    
    var UserData: [UserInfo] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbarGradientColor()
        setupAnimate()
        self.title = "看診系統"
        registerTb.delegate = self
        registerTb.dataSource = self
        registerTb?.register(UINib(nibName: "DoctorTableViewCell", bundle: nil), forCellReuseIdentifier: DoctorTableViewCell.identified)
        let user = UserInfo(age: "19", gender: "男生", name: "施翔翔", nationalId: "G12345667", tall: "192")
        let user2 = UserInfo(age: "22", gender: "中性", name: "施斌翔", nationalId: "G12345667", tall: "177")
        let user1 = UserInfo(age: "12", gender: "女生", name: "施斌斌", nationalId: "G1245567", tall: "188")
        UserData.append(user)
        UserData.append(user1)
        UserData.append(user2)
        UserData.append(user)
        UserData.append(user1)
        UserData.append(user2)
        navigationItem.hidesBackButton = true
    
    }
 
    func setupAnimate() {
        let animationView = LottieAnimationView(name: "DotBackgroundAnimate1")
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: DocV.frame.width, height: DocV.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.5)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        DocV!.addSubview(animationView)
        animationView.play()
    }
    
    
}

extension DoctorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = registerTb?.dequeueReusableCell(withIdentifier: DoctorTableViewCell.identified,
                                                   for: indexPath) as! DoctorTableViewCell
//        cell.selectionStyle = .none
        if(indexPath.row == 0) {
            cell.age.textColor = .black
            cell.gender.textColor = .black
            cell.name.textColor = .black
            cell.nationalId.textColor = .black
            cell.tall.textColor = .black
            cell.age.text = "年紀"
            cell.gender.text = "性別"
            cell.name.text = "姓名"
            cell.nationalId.text = "身份證字號"
            cell.tall.text = "身高"
            cell.selectionStyle = .none
        } else {
            cell.age.textColor = .black
            cell.gender.textColor = .black
            cell.name.textColor = .black
            cell.nationalId.textColor = .black
            cell.tall.textColor = .black
            
        if UserData[indexPath.row - 1].isChangeColor ?? false {
                   cell.age.textColor = .lightGray
                   cell.gender.textColor = .lightGray
                   cell.name.textColor = .lightGray
                   cell.nationalId.textColor = .lightGray
                   cell.tall.textColor = .lightGray
               }
            
            
            cell.age.text = UserData[indexPath.row - 1].age
            cell.gender.text = UserData[indexPath.row - 1].gender
            cell.name.text = UserData[indexPath.row - 1].name
            cell.nationalId.text = UserData[indexPath.row - 1].nationalId
            cell.tall.text = UserData[indexPath.row - 1].tall
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let vc = PatientViewController()
        vc.indexDelegate = self
        vc.index = indexPath.row - 1
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let endBtn = UIContextualAction(style: .destructive, title: "已完成") { [self] (action, view, completion) in
            print("完成第 \(indexPath.row - 1) 行")
            if let firstDo = UserData[indexPath.row - 1].isChangeColor {
                if(firstDo == false) {
                    var firstElement = UserData.remove(at: indexPath.row - 1)
                    firstElement.isChangeColor = true
                    UserData.append(firstElement)
                    registerTb.reloadData()
                } else {
                    Alert.showAlert(title: "", message: "已完成看診", vc: self, confirmTitle: "確認")
                    print("已完成看診")
                }
            }
            
            
        }
        endBtn.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [endBtn])
        return configuration
    }
    
}


struct UserInfo {
    var age: String
    var gender: String
    var name: String
    var nationalId: String
    var tall: String
    var isChangeColor: Bool? = false
}

extension DoctorViewController: Indexdelegate {
    func didSelectIndex(index: Int) {
        if let firstDo = UserData[index].isChangeColor {
            print("完成第 \(index - 1) 行")
            if(firstDo == false) {
                var firstElement = UserData.remove(at: index)
                firstElement.isChangeColor = true
                UserData.append(firstElement)
                registerTb.reloadData()
            } else {
                Alert.showAlert(title: "", message: "已完成看診", vc: self, confirmTitle: "確認")
                print("已完成看診")
            }
        }
    }
    
    
}
