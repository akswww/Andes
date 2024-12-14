//
//  TabbarViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/7.
//

import UIKit
import Lottie

class TabbarViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBarView: CustomTabBarView!
    
    @IBOutlet weak var backAnimate: UIView!
    
    var vc: [UIViewController] = []
    var personalInformationVC = MainUserViewController()
    var medicalInformationVC = AIMapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc = [personalInformationVC,medicalInformationVC]
        
        // 預設進來的頁面是第 1 頁
        updateView(index: 0)
        
        setupUI()
        setupAnimate()
    }
    
    func setupUI() {
       
        tabBarView.onItemsTapped = {
            self.updateView(index: $0) // $0 從第一個開始掃描
        }
        tabBarView.layer.cornerRadius = 20
        tabBarView.layer.masksToBounds = true
        backAnimate.layer.cornerRadius = 20
        backAnimate.layer.masksToBounds = true
        navigationItem.hidesBackButton = true
    }

    func setupAnimate() {
        let animationView = LottieAnimationView(name: "DotBackgroundAnimate")
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        animationView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:  UIScreen.main.bounds.size.height * 0.5)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        backAnimate!.addSubview(animationView)
        animationView.play()
    }
    
    func updateView(index: Int) {
        // 會逐個掃描，並把 vc 裡 children 沒有的 view 放進 children 裡
        if children.first(where: { String(describing: $0.classForCoder) == String(describing: vc[index].classForCoder) }) == nil {
            addChild(vc[index])
            vc[index].view.frame = containerView.bounds
        }
        navigationItem.title = tabBarView.vcTitleArray[index]
        // 將中間的 container 替換成閉包, delegate 帶進來的值
        containerView.addSubview(vc[index].view)
    }
    
}
