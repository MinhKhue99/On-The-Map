//
//  User.swift
//  On The Map
//
//  Created by KhuePM on 02/05/2024.
//

import Foundation

struct User {
    var sessionId: String
    var userId: String
    var userInfo: UserInfo?
}

struct UserInfo {
    var firstName: String
    var lastName: String
}
