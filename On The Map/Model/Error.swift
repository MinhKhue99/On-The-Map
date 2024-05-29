//
//  Error.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct ErrorResponse: Codable, LocalizedError {
    let status: Int
    let error: String
    
    var errorDescription: String? {
        return NSLocalizedString(self.error, comment: "")
    }
}
