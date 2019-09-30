//
//  APIManager.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import Foundation

typealias SuccessCompletion = ()->Void
typealias SuccessCompletionWithObject<T> = (T)->Void
typealias ErrorCompletion = (Error) -> Void

final class APIManager {
 
    private static let keychainKey = Bundle.main.bundleIdentifier!
    private static var token: String?
//    {
//        set {
//            if let newValue = newValue {
//                KeychainWrapper.standard.set(newValue, forKey: keychainKey)
//            } else {
//                KeychainWrapper.standard.removeObject(forKey: keychainKey)
//            }
//        }
//        
//        get {
//            return KeychainWrapper.standard.string(forKey: keychainKey)
//        }
//    }
    
    public static var hasToken: Bool { return token != nil }
    public static var shared: APIManager = APIManager()
    
//    private let baseURL = URL(string: "https://someapi")!
    
    static func reset() {
        token = nil
    }
}

// A 'Don't Touch' Zone. As planned - next code shouldn't be edited at all in future

private extension APIManager {
    
    enum RequestTypes: String {
        case GET = "GET"
        case POST = "POST"
        case DELETE = "DELETE"
        case PUT = "PUT"
    }
    
    func perform<T: Decodable>(_ requestType: RequestTypes,
                               to url: URL,
                               with parameters: [String: String]? = nil,
                               and headers: [String: String]? = nil,
                               _ successCompletion: SuccessCompletionWithObject<T>? = nil,
                               _ errorCompletion: ErrorCompletion? = nil) {
        var mutableUrl = url
        if var urlComponents = URLComponents(url: mutableUrl, resolvingAgainstBaseURL: true), parameters != nil {
            urlComponents.queryItems = []
            parameters?.forEach { urlComponents.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value)) }
            mutableUrl = urlComponents.url ?? url
        }
        
        var urlRequest = URLRequest(url: mutableUrl)
        urlRequest.httpMethod = requestType.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        if let token = APIManager.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorCompletion?(error)
                }
                return
            } else if let httpResponse = response as? HTTPURLResponse,
                !(200...399).contains(httpResponse.statusCode),
                let data = data {
                
                let errorMessage = String(data: data, encoding: .utf8) ?? ""
                DispatchQueue.main.async {
                    errorCompletion?(NSError(domain: errorMessage,
                                             code: httpResponse.statusCode,
                                             userInfo: httpResponse.allHeaderFields as? [String: Any]))
                }
                return
            } else if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    let decodedObject = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        successCompletion?(decodedObject)
                    }
                    return
                } catch let error {
                    DispatchQueue.main.async {
                        errorCompletion?(error)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                errorCompletion?(NSError(domain: "Unknown Error", code: 0, userInfo: nil))
            }
        }.resume()
    }
}
