//
//  CreategroupVC.swift
//  Blue
//
//  Created by sHiKoOo on 2/18/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit
import Firebase

class CreategroupVC: UIViewController {
    
    @IBOutlet weak var titleTxt: InsetTextField!
    @IBOutlet weak var descTxt: InsetTextField!
    @IBOutlet weak var emailTxt: InsetTextField!   // working as search bar
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var addPeopleLbl: UILabel!   // to show the chosen emails from emailTxt
    
    var emailArray = [String]()   // to hold the emails we serach in emailTxt from Database users
    var chosenUserArray = [String]()  // to hold the emails of users we choosed them from tableview while searching
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        emailTxt.delegate = self
        emailTxt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    @objc func textFieldChanged() {
        if emailTxt.text == "" {
            emailArray = []
            tableview.reloadData()
        }else {
            DataService.instance.getEmail(forSearchQuery: emailTxt.text!) { (resultEmail) in
                self.emailArray = resultEmail
                self.tableview.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        if titleTxt.text != "" && descTxt.text != "" {
            // get id from emails we chosen and added to array
            DataService.instance.getids(forUsernames: chosenUserArray) { (resultIdsArray) in
                var userIds = resultIdsArray
                userIds.append((Auth.auth().currentUser?.uid)!)   // add myself auto
                
                DataService.instance.createGroup(forTitle: self.titleTxt.text!, andDescription: self.descTxt.text!, forUserIds: userIds, handler: { (success) in
                    if success {   // created group success
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        print("Group could not be created !")
                    }
                })
                
                
            }
        }
    }
    
    
    
    
}



extension CreategroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell {
            let image = UIImage(named: "defaultProfileImage")
            
            if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: image!, email: emailArray[indexPath.row], isSelected: true)
            } else {
                cell.configureCell(profileImage: image!, email: emailArray[indexPath.row], isSelected: false)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell {
            if !chosenUserArray.contains(cell.emailLbl.text!) {
                chosenUserArray.append(cell.emailLbl.text!)
                addPeopleLbl.text = chosenUserArray.joined(separator: ", ")   // add the chosen emails from array to addPeopleLbl with separator
                doneBtn.isHidden = false
            }else {
                // when select email that we chosen before and want to remove it (filter the array and return all exept the selected)
                chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLbl.text!})
                if chosenUserArray.count >= 1 {
                    addPeopleLbl.text = chosenUserArray.joined(separator: ", ")
                }else {
                    addPeopleLbl.text = "Add people"
                    doneBtn.isHidden = true
                }
            }
        }else { return }
    }
    
}


extension CreategroupVC: UITextFieldDelegate {
    
}
