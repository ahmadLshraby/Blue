//
//  Group.swift
//  Blue
//
//  Created by sHiKoOo on 2/18/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import Foundation

// when select a group it opens a new screen that will be filled by data from this model which got it from Database
class Group {
    private var _title: String
    private var _desc: String
    private var _memberCount: Int
    private var _members: [String]
    private var _key: String
    
    var groupTitle: String {
        return _title
    }
    var groupDesc: String {
        return _desc
    }
    var membersCount: Int {
        return _memberCount
    }
    var members: [String] {
        return _members
    }
    var key: String {
        return _key
    }
    
    init(title: String, description: String, membersCount: Int, members: [String], key: String) {
        self._title = title
        self._desc = description
        self._memberCount = membersCount
        self._members = members
        self._key = key
    }
}
