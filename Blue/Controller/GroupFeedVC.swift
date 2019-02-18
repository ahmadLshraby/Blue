//
//  GroupFeedVC.swift
//  Blue
//
//  Created by sHiKoOo on 2/18/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class GroupFeedVC: UIViewController {

    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTxt: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        sendView.bindToKeyboard()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
    }
    

}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell {
            
            return cell
        }
        
        return UITableViewCell()
    }
}
