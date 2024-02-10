//
//  UnsplashRepository.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation
import Combine

protocol UnsplashRepository {
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error>
}

final class UnsplashRepositoryImplementation: UnsplashRepository {
    private let sessionProvider: URLSessionProvider
    private let decoder: JSONDecoder
    
    init(sessionProvider: URLSessionProvider, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error> {
        let endPoint = UnsplashEndPoint()
        guard let url = endPoint.url(pageNumber: page) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return sessionProvider.requestData(url: url, header: nil)
            .decode(type: [Photo].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
