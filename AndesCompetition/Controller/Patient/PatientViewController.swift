//
//  PatientViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 12/12/24.
//

import UIKit
import Lottie


class PatientViewController: BaseViewController {

    @IBOutlet weak var vDOC: UIView!
    
    @IBOutlet weak var tvDoc: UITextView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbGender: UILabel!
    
    @IBOutlet weak var lbTall: UILabel!
    
    @IBOutlet weak var lbWeight: UILabel!
    
    weak var indexDelegate: Indexdelegate?
    
    let manager = NetworkManager()
    
    var index: Int!
    
    var firstFloor: [String] = []
    
    var secondFloor: [String] = []
    
    var threeFloor: [String] = []
    
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
        } backAction: { [self] in
            print(firstFloor,secondFloor,threeFloor)
            let request: ClinicRequest = ClinicRequest(appointment_clinic: Appointment_clinic(first: firstFloor, second: secondFloor, third: threeFloor))
            
            let medicalrequest: medicalRequest = medicalRequest(date: tvDoc.text ?? "")
            Task {
                let result: BaseReponse = try await manager.requestData(method: .post, path: .appoint, parameters: request)
                if(result.result == 0) {
                    let result: BaseReponse = try await manager.requestData(method: .post, path: .medical, parameters: medicalrequest)
                    if(result.result == 0 ) {
                        self.indexDelegate?.didSelectIndex(index: self.index)
                        self.dismiss(animated: true)
                    }
                }
            }
   
        }
    }

    func handleFloorSelection(_ selection: Int) {
        switch selection {
        case 0:
            Alert.showActionSheetMultiSelect(array: ["耳鼻喉科", "眼科", "嘴科"], canceltitle: "返回", confirmTitle: "", vc: self) { [self] confirm in
                print(confirm.description)
                if(confirm.description == "0") {
                    if((firstFloor.contains("耳鼻喉科"))) {
                        firstFloor.removeAll(where: { $0 == "耳鼻喉科" })
                    } else {
                        firstFloor.append("耳鼻喉科")
                    }
                } else if (confirm.description == "1") {
                    if((firstFloor.contains("眼科"))) {
                        firstFloor.removeAll(where: { $0 == "眼科" })
                    } else {
                        firstFloor.append("眼科")
                    }
                } else if(confirm.description == "2") {
                    if((firstFloor.contains("嘴科"))) {
                        firstFloor.removeAll(where: { $0 == "嘴科" })
                    } else {
                        firstFloor.append("嘴科")
                    }
                }
                
            } backAction: {
                self.showFloorSelection()
            }

        case 1:
            Alert.showActionSheetMultiSelect(array: ["牙科", "內科", "外科"], canceltitle: "返回", confirmTitle: "", vc: self) { [self] confirm in
                if(confirm.description == "0") {
                    if((secondFloor.contains("牙科"))) {
                        secondFloor.removeAll(where: { $0 == "嘴科" })
                    } else {
                        secondFloor.append("牙科")
                    }
                } else if (confirm.description == "1") {
                    if((secondFloor.contains("內科"))) {
                        secondFloor.removeAll(where: { $0 == "內科" })
                    } else {
                        secondFloor.append("內科")
                    }
                } else if(confirm.description == "2") {
                    if((secondFloor.contains("外科"))) {
                        secondFloor.removeAll(where: { $0 == "外科" })
                    } else {
                        secondFloor.append("外科")
                    }
                }
            } backAction: {
                self.showFloorSelection()
            }
        case 2:
            Alert.showActionSheetMultiSelect(array: ["手科", "腳科", "腿科"], canceltitle: "返回", confirmTitle: "", vc: self) { [self] confirm in
                if(confirm.description == "0") {
                    if(threeFloor.contains("手科")) {
                        threeFloor.removeAll(where: { $0 == "手科" })
                    } else {
                        threeFloor.append("手科")
                    }
                } else if (confirm.description == "1") {
                    if((threeFloor.contains("腳科"))) {
                        threeFloor.removeAll(where: { $0 == "腳科" })
                    } else {
                        threeFloor.append("腳科")
                    }
                } else if(confirm.description == "2") {
                    if((threeFloor.contains("腿科"))) {
                        threeFloor.removeAll(where: { $0 == "腿科" })
                    } else {
                        threeFloor.append("腿科")
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
