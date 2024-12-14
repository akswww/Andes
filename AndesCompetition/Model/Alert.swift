//
//  Alert.swift
//  Smart Healthcare App
//
//  Created by Gary on 2023/6/8.
//

import UIKit

public class Alert{
    
    static func showAlert(title: String,
                   message: String,
                   vc: UIViewController,
                   confirmTitle: String,
                   confirmAction: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let confirm = UIAlertAction(title: confirmTitle, style: .default) { action in
                confirmAction?()
            }
            alertController.addAction(confirm)
            vc.present(alertController, animated: true)
        }
    }
    
    static func showAlert(title: String,
                   message: String,
                   vc: UIViewController,
                   confirmTitle: String,
                   cancelTitle: String,
                   confirmAction: (() -> Void)? = nil,
                   cancelAction: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let confirm = UIAlertAction(title: confirmTitle, style: .default) { action in
                confirmAction?()
            }
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancelAction?()
            }
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            vc.present(alertController, animated: true)
        }
    }

    static func showActionSheet(array: [String],
                                    canceltitle: String,
                                    vc: UIViewController,
                                    confirm: ((Int) -> Void)? = nil,
                                    backAction: (() -> Void)? = nil) {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: nil,
                                                        message: nil,
                                                        preferredStyle: .actionSheet)
                
                for option in array {
                    let action = UIAlertAction(title: option, style: .default) { action in
                        print(action)
                        let index = array.firstIndex(of: option)
                        confirm?(index!)
                    }
                    action.setValue(UIColor.blue, forKey: "titleTextColor")
                    alertController.addAction(action)
                }
                let cancelAction = UIAlertAction(title: canceltitle, style: .cancel) { action in
                    backAction?()
                }
                cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
                alertController.addAction(cancelAction)
                vc.present(alertController,animated: true)
            }
        }
    
    static func showActionSheetMultiSelect(array: [String],
                                             canceltitle: String,
                                             confirmTitle: String,
                                             vc: UIViewController,
                                             selectedIndices: Set<Int> = [],
                                           confirm: ((Int) -> Void)? = nil,
                                             backAction: (() -> Void)? = nil) {
            DispatchQueue.main.async {
                var currentSelectedIndices = selectedIndices // 使用傳入的選擇狀態
                
                let alertController = UIAlertController(title: nil, message: "選擇複診的診間", preferredStyle: .alert)
                
                for (index, option) in array.enumerated() {
                    let isSelected = currentSelectedIndices.contains(index)
                    let toggleAction = UIAlertAction(title: "\(isSelected ? "✓ " : "")\(option)", style: .default) { _ in
                        if currentSelectedIndices.contains(index) {
                            currentSelectedIndices.remove(index)
                            confirm?(index)
                        } else {
                            currentSelectedIndices.insert(index)
                            confirm?(index)
                        }
                        
                        // 遞迴呼叫時傳入當前的選擇狀態
                        showActionSheetMultiSelect(array: array,
                                                canceltitle: canceltitle,
                                                confirmTitle: confirmTitle,
                                                vc: vc,
                                                selectedIndices: currentSelectedIndices, // 傳入更新後的選擇狀態
                                                confirm: confirm,
                                                backAction: backAction)
                    }
                    toggleAction.setValue(UIColor.blue, forKey: "titleTextColor")
                    alertController.addAction(toggleAction)
                }
                
                
                let cancelAction = UIAlertAction(title: canceltitle, style: .cancel) { _ in
                    backAction?()
                }
                cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
                alertController.addAction(cancelAction)
                
                vc.present(alertController, animated: true)
            }
        }



    
    static func showAlertWith(title: String,
                              message: String,
                              vc: UIViewController ,
                              confirmtitle: String,
                              canceltitle: String,
                              setTextField: ((UITextField) -> Void)?,
                              confirm: ((UITextField) -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addTextField { textfield in
                setTextField?(textfield)
            }
            
            let confirmAction = UIAlertAction(title: confirmtitle, style: .default) { action in
                let textField = (alertController.textFields?.first)! as UITextField
                confirm?(textField)
            }
            
            let cancel = UIAlertAction(title: canceltitle, style: .default)
            
            alertController.addAction(cancel)
            alertController.addAction(confirmAction)
            
            vc.present(alertController, animated: true)
        }
    }
}
