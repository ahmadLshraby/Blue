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
    
    // MARK: POST NEW FEED IN DATABASE FEED upload post has inputs (message, sender id, public or in group)
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, postCompletion: @escaping(_ status: Bool) -> Void) {
        if groupKey != nil {
            // post to groups ref
        }else {
            // post to feed ref
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            postCompletion(true)
        }
    }
    
    // MARK: GET ALL FEED FROM DATABASE FEED
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
                // create message in the Model
                let message = Message(content: content, senderId: senderId)
                // add this message to our messageArray to be used
                messageArray.append(message)
            }
            getCompletion(messageArray)
            
        }
    }
    
    // MARK: CONVERT USERID TO EMAIL
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
    
    // MARK: SEARCH FOR USER and return [String]
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
    
    
}
