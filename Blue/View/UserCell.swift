//
//  UserCell.swift
//  Blue
//
//  Created by sHiKoOo on 2/18/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false    // to flip flop the checkImage
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true   {
            if showing == false {
                checkImage.isHidden = false
                showing = true
            }else {
                checkImage.isHidden = true
                showing = false
            }
        }
    }
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
        self.profileImage.image = image
        self.emailLbl.text = email
        if isSelected == true {
            self.checkImage.isHidden = false
        }else {
            self.checkImage.isHidden = true
        }
    }
    
}
