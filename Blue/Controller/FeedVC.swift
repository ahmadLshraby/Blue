//
//  FirstViewController.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // download the messages from feed child in Database as array
        DataService.instance.getAllFeedMessage { (downloadedMessageArray) in
            self.messageArray = downloadedMessageArray.reversed()  // to reverse the view of the array (reversed collection <([])>)
            self.tableview.reloadData()
        }
    }


}

// MARK: CONFIGURE TABLEVIEW
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell {
        let image = UIImage(named: "defaultProfileImage")
            let message = messageArray[indexPath.row]
            
            DataService.instance.getUsername(forUID: message.senderId) { (resultUsername) in
                cell.configureCell(profileImage: image!, email: resultUsername, content: message.content)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
}

