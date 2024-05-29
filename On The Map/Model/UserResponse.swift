//
//  UserResponse.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct UserResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
