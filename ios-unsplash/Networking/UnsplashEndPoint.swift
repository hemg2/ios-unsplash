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
    private let searchPath: String = "/search/photos"
    private let apiKey: String = APIKey.unsplash
    
    func url(pageNumber: Int) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "client_id", value: apiKey)
        ]
        
        return component.url
    }
}

// MARK: searchURL
extension UnsplashEndPoint {
    func searchURL(query:String, pageNumber: Int) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = searchPath
        component.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "client_id", value: apiKey)
        ]
        
        return component.url
    }
}
