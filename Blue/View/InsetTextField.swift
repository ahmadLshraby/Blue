//
//  InsetTextField.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        let placeHolder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeHolder
    }
    

}
