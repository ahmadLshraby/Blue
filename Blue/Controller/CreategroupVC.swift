//
//  CreategroupVC.swift
//  Blue
//
//  Created by sHiKoOo on 2/18/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class CreategroupVC: UIViewController {

    @IBOutlet weak var titleTxt: InsetTextField!
    @IBOutlet weak var descTxt: InsetTextField!
    @IBOutlet weak var emailTxt: InsetTextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var addPeopleLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
    }
    
    
 

}



extension CreategroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell {
            let image = UIImage(named: "defaultProfileImage")

            
            cell.configureCell(profileImage: image!, email: "s", isSelected: true)
            return cell
        }
        
        return UITableViewCell()
    }
    
}
