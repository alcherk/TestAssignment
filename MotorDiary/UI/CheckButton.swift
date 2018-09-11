//
//  CheckButton.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import UIKit

class CheckButton: UIButton {
    private let checkedImage = #imageLiteral(resourceName: "checkbox_selected")
    private let uncheckedImage = #imageLiteral(resourceName: "checkbox_empty")
    
    var isChecked: Bool = false {
        didSet {
            updateImage(isChecked)
        }
    }
    
    public var valueChanged: ((_ sender: CheckButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            valueChanged?(self)
        }
    }
    
    private func updateImage(_ checked: Bool) {
        self.setImage(checked ? checkedImage : uncheckedImage, for: UIControlState.normal)
    }
}
