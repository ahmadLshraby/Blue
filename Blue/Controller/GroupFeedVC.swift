//
//  GroupFeedVC.swift
//  Blue
//
//  Created by sHiKoOo on 2/18/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTxt: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    // define var to hold all the messages we get from Database
    var groupMessage = [Message]()
    // define var from Model Group to take data from it and pass it here
    var group: Group?
    // delegate method will call it in select row at GroupsVC
    func initData(forGroup group: Group) {  // we can access all data in the Model
        self.group = group
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLbl.text = group?.groupTitle
        
        DataService.instance.getEmails(forGroup: group!) { (returnEmails) in  // convert id to email
            self.membersLbl.text = returnEmails.joined(separator: ", ")
        }
//        membersLbl.text = group?.members.joined(separator: ", ")  // as members in the Model is [] so we get joined (all who join the []) this get the id of members , so we call the above func
        
        // Get all GROUPS and then Get all the messages for the selected group
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessages(forGroup: self.group!, handler: { (returnMessages) in
                self.groupMessage = returnMessages
                self.tableview.reloadData()
                // scrolling animationg to the LAST message in the array (consider array count start 0)send , tableview must have a message
                if self.groupMessage.count > 0 {
                    self.tableview.scrollToRow(at: IndexPath(row: self.groupMessage.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        sendView.bindToKeyboard()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismissDetail()    // Extension to UIViewController for animation dismiss VC
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        if messageTxt.text != "" {
            messageTxt.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTxt.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key) { (success) in
                if success {
                    self.messageTxt.text = ""  // to reset the text field
                    self.messageTxt.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
            }
        }
    }
    

}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell {
            let message = groupMessage[indexPath.row] // to extract the data from the message and pass to cell
            // message has content and senderId , so we will get email from uid
            DataService.instance.getUsername(forUID: message.senderId) { (email) in
                cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
            }
            return cell
        }
        return UITableViewCell()
    }
}
