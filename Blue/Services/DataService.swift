//
//  DataService.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    // private set the variables
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    // public get the variables
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    // MARK: CREATE USER IN DATABASE OF USERS push information to Database
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    // MARK: CREATE NEW FEED IN DATABASE FEED upload post has inputs (message, sender id, public or in group)
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, postCompletion: @escaping(_ status: Bool) -> Void) {
        if groupKey != nil {
            // post to groups ref
        }else {
            // post to feed ref
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            postCompletion(true)
        }
    }
    
    // MARK: GET ALL FEED FROM DATABASE FEED  and return array of Message Model
    func getAllFeedMessage(getCompletion: @escaping(_ messages: [Message]) -> Void) {
        // make empty array for our Message Model
        var messageArray = [Message]()
        
        REF_FEED.observeSingleEvent(of: .value) { (snapshot) in
            // get allObjects from snapshot and put them in array as [DataSnapshot]
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // get the data from snapshot
            for message in snapshot {
                // get the value of the key "content"
                let content = message.childSnapshot(forPath: "content").value as! String
                // get the value of key "senderId"
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                // build a message in the Model
                let message = Message(content: content, senderId: senderId)
                // add this message to our messageArray to be used
                messageArray.append(message)
            }
            getCompletion(messageArray)
            
        }
    }
    
    // MARK: CONVERT USERID TO EMAIL  //to add them to FeedVC tableview
    func getUsername(forUID uid: String, completion: @escaping(_ username: String) -> Void) {
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            // get allObjects from snapshot and put them in array as [DataSnapshot]
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // get the data from snapshot
            for user in snapshot {
                if user.key == uid {   // user has child "uid" as we entered it in func createDBUser
                    completion(user.childSnapshot(forPath: "email").value as! String)   // get in user -> key "email" -> value
                }
            }
        }
    }
    
    // MARK: GET, SEARCH FOR USER and return [String]  // to search in CreateGroupVC
    func getEmail(forSearchQuery query: String, handler: @escaping(_ emailArray: [String]) -> Void) {
        // make empty array for save our search query in it
        var emailArray = [String]()
        
        REF_USERS.observe(.value) { (snapshot) in
            // get allObjects from snapshot and put them in array as [DataSnapshot]
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
           // get the data from snapshot
            for user in snapshot {
                // get the value of key "email"
                let email = user.childSnapshot(forPath: "email").value as! String
                // search the email by contains string and my email not in the search
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    // MARK: CONVERT USERNAMES TO UID  to show them in groups
    func getids(forUsernames usernames: [String], handler: @escaping(_ uidArray: [String]) -> Void) {
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            var idArray = [String]()
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapshot {
                let email = user.childSnapshot(forPath: "email").value as! String  // get the email value to check
                if usernames.contains(email) {  // check if the email is in the input of the function
                    idArray.append(user.key)  // get the key of that email (as email is the value and key is uid) and add it to the array
                }
            }
            handler(idArray)
        }
    }
    
    // MARK: GET EMAIL from Model in members take key (id) we get the email value for these members
    func getEmails(forGroup group: Group, handler: @escaping(_ emailArray: [String]) -> Void) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    // MARK: CREATE GROUP  that has title, description, list of emails that we converted them to uid
    func createGroup(forTitle title: String, andDescription description: String, forUserIds uids: [String], handler: @escaping(_ groupCreated: Bool) -> Void) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": uids])
        handler(true)
    }
    
    // MARK: GET ALL GROUPS FROM DATABASE GROUPS and return array of Group Model
    func getAllGroups(handler: @escaping(_ groupsArray: [Group]) -> Void) {
        // make empty array for our Group Model
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            // get allObjects from snapshot and put them in array as [DataSnapshot]
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // get the data from snapshot
            for group in snapshot {
                // get the value of the key "members" as its an [] in the Database
                let membersArray = group.childSnapshot(forPath: "members").value as! [String]
                
                // get only the groups we are in , not all the groups
                if membersArray.contains((Auth.auth().currentUser?.uid)!) {
                    // build a group in Group Model by get the value from Database and pass it to the Model
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(title: title, description: description, membersCount: membersArray.count, members: membersArray, key: group.key)
                    
                    // add this message to our messageArray to be used
                    groupsArray.append(group)
                }

            }
            handler(groupsArray)
            
        }
    }
    
    
}
