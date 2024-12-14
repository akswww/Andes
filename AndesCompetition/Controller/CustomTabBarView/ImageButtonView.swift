//
//  ImageButtonView.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/6.
//

import UIKit

class ImageButtonView: UIView {

    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var delegate: ImageButtonViewDelegate?
    
    override func awakeFromNib() {
        addXibView()
    }
    
    // view 在設計時想要看到畫面要用這個
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addXibView()
    }
    
    func setInit(imageName: String,
                 labelText: String,
                 index: Int,
                 delegate: ImageButtonViewDelegate) {
        image?.image = UIImage(systemName: imageName)
        label?.text = labelText
        label?.textColor = .black
        button?.setTitle("", for: .normal)
        button?.tag = index
        self.delegate = delegate
    }
    @IBAction func btnClick(_ sender: UIButton) {
        delegate?.imageButtonView(didClickAt: sender.tag)
    }
    
}

fileprivate extension ImageButtonView {
    // 加入畫面
    func addXibView() {
        if let loadView = Bundle(for: ImageButtonView.self)
            .loadNibNamed("ImageButtonView",
                          owner: self,
                          options: nil)?.first as? UIView {
            addSubview(loadView)
            loadView.frame = bounds
        }
    }
}
protocol ImageButtonViewDelegate {
    
    func imageButtonView(didClickAt index: Int)
}
