//
//  UserService.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct UserService {
    static func getUserInfo(userId: String, completionHandler: @escaping (UserInfo?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.user(userId).url)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard var data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }
            
            data = data.subdata(in: 5..<data.count)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    debugPrint(error)
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(UserResponse.self, from: data)
                let userInfo = UserInfo(firstName: responseData.firstName, lastName: responseData.lastName)
                DispatchQueue.main.async {
                    completionHandler(userInfo, nil)
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
    
    static func getStudentLocations(limit: Int?, completionHandler: @escaping ([StudentLocation]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocations(limit).url)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    debugPrint(error)
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(StudentLocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseData.results, nil)
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
    
    static func saveStudentLocation(
        uniqueKey: String,
        firstName: String,
        lastName: String,
        mapString: String,
        mediaURL: String,
        latitude: Double,
        longitude: Double,
        completionHandler: @escaping (StudentLocation?, Error?) -> Void
    ) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = StudentLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        request.httpBody = try! JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(StudentLocation(objectId: responseData.objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: responseData.createdAt, updatedAt: responseData.createdAt), nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
}
