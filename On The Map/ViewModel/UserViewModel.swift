//
//  UserViewModel.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation
import UIKit
import SwiftUI
import MapKit

class UserViewModel: ObservableObject {
    @Published var studentLocations = [StudentLocation]()
    @Published var isLoading = false
    @Published var error: Error?
    @Published var user: User?
    @Published var place: CLPlacemark? = nil
    @Published var mediaURL: String = ""
    @Published var showPreview: Bool = false
    @Published var mapString = ""
    @Published var alert: AlertContent?
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    static let shared = UserViewModel()
    
    
    func login(username: String, password: String) {
        self.isLoading = true
        AuthService.login(username: username, password: password) { user, loginError in
            guard let user = user else {
                self.isLoading = false
                self.alert = AlertContent(
                    title: "Login Failed",
                    message: loginError?.localizedDescription ?? "Something unexpected occcurred."
                )
                return
            }
            self.user = user
            UserService.getUserInfo(userId: user.userId) { userInfo, getUserInfoError in
                self.isLoading = false
                guard let userInfo = userInfo else {
                    self.alert = AlertContent(title: "Login Fail", message: getUserInfoError?.localizedDescription ?? "")
                    return
                }
                debugPrint("KhuePM userInfo: \(userInfo)")
                self.user?.userInfo = userInfo
                self.isLoggedIn = true
                self.fetchStudentLocations()
            }
        }
    }
    
    func logout(sessionId: String) {
        AuthService.logout(sessionId: sessionId){ success, logourError in
            if success {
                self.user = nil
                self.isLoggedIn = false
            } else {
                self.alert = AlertContent(title: "Logout Fail", message: logourError?.localizedDescription ?? "")
            }
        }
    }
    
    func onLoggedIn(user: User) {
        self.user = user
    }
    
    func fetchStudentLocations() {
        self.isLoading = true
        UserService.getStudentLocations(limit: 100) {studentLocations, error in
            guard var studentLocations = studentLocations else {
                self.isLoading = false
                self.alert = AlertContent(title: "Get Student Locations Fail", message: error?.localizedDescription ?? "")
                return
            }
            studentLocations.sort {
                $0.updatedAt > $1.updatedAt
            }
            self.studentLocations = studentLocations
            self.isLoading = false
        }
    }
    
    func openURL(urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
        
        self.alert = AlertContent(
            title: "Failed to open URL",
            message: "Empty or invalid media URL."
        )
    }
    
    func findLocation() {
        isLoading = true
        CLGeocoder().geocodeAddressString(self.mapString) { placeMark, error in
            self.isLoading = false
            guard let placeMark = placeMark else {
                self.alert = AlertContent(
                    title: "Find Location Fail",
                    message: error?.localizedDescription ?? ""
                )
                return
            }
            self.place = placeMark[0]
            self.showPreview = true
        }
    }
    func saveLocation() {
        isLoading = true
        guard let userInfo = self.user else {
            self.alert = AlertContent(
                title: "Save Location Fail",
                message: "Can not save location"
            )
            isLoading = false
            self.mapString = ""
            self.mediaURL = ""
            return
        }
        
        UserService.saveStudentLocation(
            uniqueKey: userInfo.userId,
            firstName: userInfo.userInfo?.firstName ?? "",
            lastName: userInfo.userInfo?.lastName ?? "",
            mapString: mapString,
            mediaURL: mediaURL,
            latitude: place!.location!.coordinate.latitude,
            longitude: place!.location!.coordinate.longitude,
            completionHandler: { studentLocation, error in
                guard let studentLocation = studentLocation else {
                    self.alert = AlertContent(
                        title: "Save Location Fail",
                        message: error?.localizedDescription ?? ""
                    )
                    return
                }
                self.studentLocations.insert(studentLocation, at: 0)
                self.isLoading = false
                self.showPreview = false
            }
        )
        self.mapString = ""
        self.mediaURL = ""
    }
}
