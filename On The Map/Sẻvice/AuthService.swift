//
//  AuthService.swift
//  On The Map
//
//  Created by KhuePM on 25/05/2024.
//

import Foundation

struct AuthService {
    static func login(username: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.auth.url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password)
        request.httpBody = try! JSONEncoder().encode(body)
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
                let responseData = try JSONDecoder().decode(LoginResponse.self, from: data)
                let user = User(sessionId: responseData.session.id, userId: responseData.account.key)
                DispatchQueue.main.async {
                    completionHandler(user, nil)
                }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
    
    static func logout(sessionId: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.auth.url)
        request.httpMethod = HTTPMethods.DELETE.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(sessionId, forHTTPHeaderField: "X-XSRF-TOKEN")
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                guard var data = data else {
                    DispatchQueue.main.async {
                        completionHandler(false, taskError)
                    }
                    return
                }
                
                data = data.subdata(in: 5..<data.count)
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(false, errorResponse)
                    }
                } catch {
                    debugPrint(error)
                    DispatchQueue.main.async {
                        completionHandler(false, taskError)
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(true, nil)
            }
        }.resume()
    }
}
