//
//  SecondViewController.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var groupArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in   // to observe any change in Database
            // download the groups from groups child in Database as array
            DataService.instance.gettAllGroups { (downloadedGroupsArray) in
                self.groupArray = downloadedGroupsArray
                self.tableview.reloadData()
        }

        }
    }


}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell {
            let group = groupArray[indexPath.row]
            cell.configureCell(title: group.groupTitle, description: group.groupDesc, members: group.membersCount)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

