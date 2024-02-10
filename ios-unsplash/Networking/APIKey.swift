//
//  APIKey.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation

enum APIKey {
    static var unsplash: String = {
        return APIKeyFromPlist(key: "Unsplash")
    }()
}

extension APIKey {
    private static func APIKeyFromPlist(key: String) -> String {
        var apiKey = ""
        
        if let path = Bundle.main.path(forResource: "Key", ofType: "plist") {
            let networkKeys = NSDictionary(contentsOfFile: path)
            
            if let networkKeys = networkKeys {
                apiKey = (networkKeys[key] as? String) ?? ""
            }
        }
        
        return apiKey
    }
}
