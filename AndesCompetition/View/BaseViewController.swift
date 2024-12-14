//
//  BaseViewController.swift
//  Smart Healthcare App
//
//  Created by Gary on 2023/6/8.
//

import UIKit

class BaseViewController: UIViewController {
 
    // 設定 Navigation Bar
    func setNavigationbar(backgroundcolor: UIColor?,
                          tintColor: UIColor = .white,
                          foregroundColor: UIColor = .white) {
        DispatchQueue.main.async {
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()
            appearence.backgroundColor = backgroundcolor
            self.navigationController?.navigationBar.tintColor = tintColor
            appearence.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : foregroundColor,
                NSAttributedString.Key.font: UIFont(name: "Timeburner", size: 20)!
            ]
            
            self.navigationController?.navigationBar.standardAppearance = appearence
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationItem.backButtonTitle = ""
        }
    }
    
    // 點擊螢幕收起鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setNavigationbarGradientColor(tintColor: UIColor = .white,
                                       foregroundColor: UIColor = .white) {
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            let sizeLength = self.view.bounds.size.width
            let frameAndStatusBar = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
            gradient.frame = frameAndStatusBar
            gradient.colors = [UIColor.ThemeColor?.cgColor as Any,
                               UIColor.TintColor?.cgColor as Any]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.locations = [1,0]
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()
            appearence.backgroundImage = self.image(fromLayer: gradient)
            
            self.navigationController?.navigationBar.tintColor = tintColor
            appearence.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : foregroundColor,
//                NSAttributedString.Key.font: UIFont(name: "Timeburner", size: 20)!
            ]
            
            self.navigationController?.navigationBar.standardAppearance = appearence
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationItem.backButtonTitle = ""
            
        }
    }
    
    func image(fromLayer layer: CAGradientLayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return outputImage
    }
}
