//
//  AlertContent.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct AlertContent: Identifiable {
    let id: String = UUID().uuidString

    let title: String
    let message: String
}
