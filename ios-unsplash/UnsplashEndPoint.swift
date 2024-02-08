//
//  UnsplashEndPoint.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation

struct UnsplashEndPoint {
    private let scheme: String = "https"
    private let host: String = "api.unsplash.com"
    private let path: String = "/photos"
    private let apiKey: String = APIKey.unsplash
    
    var url: URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "client_id", value: apiKey)
        ]
        
        return component.url
    }
}
