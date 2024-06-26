//
//  LoginRequest.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct Credential: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: Credential
    
    init(username: String, password: String) {
        self.udacity = Credential(username: username, password: password)
    }
}


struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct LogoutResponse: Codable {
    let session: Session
}
