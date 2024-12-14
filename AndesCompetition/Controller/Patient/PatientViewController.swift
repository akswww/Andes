//
//  PatientViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 12/12/24.
//

import UIKit
import Lottie


class PatientViewController: UIViewController {

    @IBOutlet weak var vDOC: UIView!
    @IBOutlet weak var tvDoc: UITextView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbGender: UILabel!
    
    @IBOutlet weak var lbTall: UILabel!
    
    @IBOutlet weak var lbWeight: UILabel!
    
    weak var indexDelegate: Indexdelegate?
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        setTextView()
        setLoginView()
        setupAnimate()
    }
    
    
    func setTextView() {
        tvDoc.layer.borderWidth = 1.0
        tvDoc.layer.borderColor = UIColor.black.cgColor
    }
    
    func setLoginView() {
        DispatchQueue.main.async {
            self.btnNext?.layer.cornerRadius = 10
            self.btnNext?.layer.borderWidth = 2
            self.btnNext?.layer.borderColor = UIColor.lightGray.cgColor
            self.btnNext?.layer.backgroundColor = UIColor.gray.cgColor
            self.btnNext?.tintColor = .white
            self.btnNext?.semanticContentAttribute = .forceRightToLeft
        }
    }

    func setupAnimate() {
        let animationView = LottieAnimationView(name: "DotBackgroundAnimate1")
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: vDOC.frame.width, height: vDOC.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.5)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        vDOC!.addSubview(animationView)
        animationView.play()
    }
    
    func showFloorSelection() {
        Alert.showActionSheetMultiSelect(array: ["一樓", "二樓", "三樓"], canceltitle: "確定", confirmTitle: "", vc: self) { confirm in
            self.handleFloorSelection(confirm)
        } backAction: {
            self.indexDelegate?.didSelectIndex(index: self.index)
            self.dismiss(animated: true)
        }
    }

    func handleFloorSelection(_ selection: Int) {
        switch selection {
        case 0:
            Alert.showActionSheetMultiSelect(array: ["耳鼻喉科", "眼科", "嘴科"], canceltitle: "返回", confirmTitle: "", vc: self) { confirm in
                print(confirm.description)
                if(confirm.description == "0") {
                    if(UserPreferences.shared.clinic.contains("耳鼻喉科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "耳鼻喉科" })
                    } else {
                        UserPreferences.shared.clinic.append("耳鼻喉科")
                    }
                } else if (confirm.description == "1") {
                    if(UserPreferences.shared.clinic.contains("眼科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "眼科" })
                    } else {
                        UserPreferences.shared.clinic.append("眼科")
                    }
                } else if(confirm.description == "2") {
                    if(UserPreferences.shared.clinic.contains("嘴科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "嘴科" })
                    } else {
                        UserPreferences.shared.clinic.append("嘴科")
                    }
                }
                print(UserPreferences.shared.clinic)
            } backAction: {
                self.showFloorSelection()
            }

        case 1:
            Alert.showActionSheetMultiSelect(array: ["牙科", "內科", "外科"], canceltitle: "返回", confirmTitle: "", vc: self) { confirm in
                if(confirm.description == "0") {
                    if(UserPreferences.shared.clinic.contains("牙科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "牙科" })
                    } else {
                        UserPreferences.shared.clinic.append("牙科")
                    }
                } else if (confirm.description == "1") {
                    if(UserPreferences.shared.clinic.contains("內科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "內科" })
                    } else {
                        UserPreferences.shared.clinic.append("內科")
                    }
                } else if(confirm.description == "2") {
                    if(UserPreferences.shared.clinic.contains("外科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "外科" })
                    } else {
                        UserPreferences.shared.clinic.append("外科")
                    }
                }
            } backAction: {
                self.showFloorSelection()
            }
        case 2:
            Alert.showActionSheetMultiSelect(array: ["手科", "腳科", "腿科"], canceltitle: "返回", confirmTitle: "", vc: self) { confirm in
                if(confirm.description == "0") {
                    if(UserPreferences.shared.clinic.contains("手科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "手科" })
                    } else {
                        UserPreferences.shared.clinic.append("手科")
                    }
                } else if (confirm.description == "1") {
                    if(UserPreferences.shared.clinic.contains("腳科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "腳科" })
                    } else {
                        UserPreferences.shared.clinic.append("腳科")
                    }
                } else if(confirm.description == "2") {
                    if(UserPreferences.shared.clinic.contains("腿科")) {
                        UserPreferences.shared.clinic.removeAll(where: { $0 == "腿科" })
                    } else {
                        UserPreferences.shared.clinic.append("腿科")
                    }
                }
            } backAction: {
                self.showFloorSelection()
            }
        default:
            print("Default case: Handle unknown steps.")
        }
    }



    
    @IBAction func doNext(_ sender: Any) {
        Alert.showAlert(title: "是否需要回診", message: "", vc: self, confirmTitle: "回診", cancelTitle: "不用回診", confirmAction: {
            self.showFloorSelection()
        } ,cancelAction:  {
            self.dismiss(animated: true)
        })
    }
    
}
protocol Indexdelegate: AnyObject {
    func didSelectIndex(index: Int)
}
