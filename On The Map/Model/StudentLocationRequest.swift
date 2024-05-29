//
//  StudentLocationRequest.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

struct StudentLocationResponse: Codable {
    let objectId: String
    let createdAt: String
}

struct StudentLocationsResponse: Codable {
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
