//
//  CustomTabBarView.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/6.
//

import UIKit

class CustomTabBarView: UIView {

    
    @IBOutlet weak var leftInformation: ImageButtonView!
    
    
    @IBOutlet weak var rightInfomation: ImageButtonView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var onItemsTapped: ((Int) -> ())? = nil
    
    var vcTitleArray: [String] = ["用戶資訊", "AI地圖"]
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        addXibView()
      
    }
    
    // view 在設計時想要看到畫面要用這個
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addXibView()
       
    }
    
    
    func setInit() {
        leftInformation.setInit(imageName: "person.text.rectangle",
                        labelText: vcTitleArray[0],
                        index: 0,
                        delegate: self)
        
        rightInfomation.setInit(imageName: "heart.text.square",
                                     labelText: vcTitleArray[1],
                                     index: 1,
                                     delegate: self)
//        DispatchQueue
//            .main.async {
//                let gradient = CAGradientLayer()
//                let sizeLength = self.stackView.bounds.size.width
//                let frameAndStatusBar = CGRect(x: 0, y: 0, width: sizeLength, height: self.stackView.bounds.size.height)
//                gradient.frame = frameAndStatusBar
//                gradient.colors = [UIColor.ThemeColor?.cgColor as Any,
//                                   UIColor.TintColor?.cgColor as Any]
//                gradient.startPoint = CGPoint(x: 0, y: 0)
//                gradient.endPoint = CGPoint(x: 1, y: 1)
//                gradient.locations = [1,0]
//                self.backgroundImage?.image = self.image(fromLayer: gradient)
//            }
    }
    

    
    
}
fileprivate extension CustomTabBarView {
    // 加入畫面
    func addXibView() {
        if let loadView = Bundle(for: CustomTabBarView.self)
            .loadNibNamed("CustomTabBarView",
                          owner: self,
                          options: nil)?.first as? UIView {
            addSubview(loadView)
            loadView.frame = bounds
            setInit()
        }
    }
}
extension CustomTabBarView: ImageButtonViewDelegate {
    
    // 把點選的值放進 onItemsTapped 閉包中
    func imageButtonView(didClickAt index: Int) {
        onItemsTapped?(index)
    }
}
