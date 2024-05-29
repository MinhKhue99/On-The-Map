//
//  APIEnpoint.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

enum HTTPMethods: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    static let authEndpoint = "\(Endpoints.base)/session"
    static let usersEndpoint = "\(Endpoints.base)/users"
    static let studentLocationEndpoint = "\(Endpoints.base)/StudentLocation"
    
    case auth
    case user(String)
    case getStudentLocations(Int?)
    case postStudentLocation
    
    var value: String {
        switch self {
        case .auth:
            return Endpoints.authEndpoint
        case .user(let userId):
            return "\(Endpoints.usersEndpoint)/\(userId)"
        case .getStudentLocations(let limit):
            if let limit = limit {
                return "\(Endpoints.studentLocationEndpoint)?limit=\(limit)"
            }
            return Endpoints.studentLocationEndpoint
        case .postStudentLocation:
            return Endpoints.studentLocationEndpoint
        }
    }
    
    var url: URL {
        return URL(string: value)!
    }
    
}
