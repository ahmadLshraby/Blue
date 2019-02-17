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
    
    // push information to Database
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    // upload post has inputs (message, sender id, public or in group)
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, postCompletion: @escaping(_ status: Bool) -> Void) {
        if groupKey != nil {
            // post to groups ref
        }else {
            // post to feed ref
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            postCompletion(true)
        }
    }
    
}
