//
//  CreatePostVC.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        sendBtn.bindToKeyboard()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        if textView.text != nil && textView.text != "Say somthing here ..." {

            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (success) in
                if success {
                    self.sendBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.sendBtn.isEnabled = true
                    print("There was an error")
                }
            }
        }
    }
    



}


extension CreatePostVC: UITextViewDelegate {
    // make it as placeholder ( textView doesn't has placeholder so we make it by code )
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
