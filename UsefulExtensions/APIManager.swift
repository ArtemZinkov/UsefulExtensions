//
//  APIManager.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import Foundation

class APIManager {
    open lazy var shared: APIManager = APIManager()
    
    func get<T: Decodable>(from url: URL,
                           _ aDecodable: T.Type,
                           _ successCompletion: ((T) -> Void)? = nil,
                           _ errorCompetion: ((Error) -> Void)? = nil) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                errorCompetion?(error)
                return
            } else if let httpResponse = response as? HTTPURLResponse,
                !(200...399).contains(httpResponse.statusCode) {
                errorCompetion?(NSError(domain: httpResponse.debugDescription,
                                        code: 0,
                                        userInfo: httpResponse.allHeaderFields as? [String: Any]))
                return
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedObject = try decoder.decode(aDecodable.self, from: data)
                    
                    successCompletion?(decodedObject)
                } catch let error {
                    errorCompetion?(error)
                }
                
                return
            }
            
            errorCompetion?(NSError(domain: "Unknown Error", code: 0, userInfo: nil))
        }.resume()
    }
}
