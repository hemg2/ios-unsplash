//
//  UnsplashRepository.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation

protocol UnsplashRepository {
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void)
}

final class UnsplashRepositoryImplementation: UnsplashRepository {
    private let sessionProvider: URLSessionProvider
    private let decoder: JSONDecoder
    
    init(sessionProvider: URLSessionProvider, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = UnsplashEndPoint().url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        sessionProvider.requestData(url: url, header: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let photos = try self.decoder.decode([Photo].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
