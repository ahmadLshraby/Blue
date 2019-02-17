//
//  ShadowView.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

}
