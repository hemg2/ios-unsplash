//
//  URLSessionProvider.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation
import Combine

protocol URLSessionProvider {
    func requestData(url: URL?, header: [String: String]?) -> AnyPublisher<Data, APIError>
}

final class URLSessionProviderImplementation: URLSessionProvider {
    private var dataTasks: [URL: URLSessionDataTask] = [:]
    
    func requestData(url: URL?, header: [String: String]?) -> AnyPublisher<Data, APIError> {
        guard let url = url, var urlRequest  = setUpURLRequest(url: url, header: header) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        header?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw APIError.invalidHTTPStatusCode
                }
                return output.data
            }
            .mapError { error -> APIError in
                (error as? APIError) ?? .requestFail
            }
            .eraseToAnyPublisher()
    }
    
    func cancelRequest(for url: URL) {
        dataTasks[url]?.cancel()
        dataTasks.removeAll()
    }
    
    func cancelAllRequests() {
        dataTasks.forEach { $0.value.cancel() }
        dataTasks.removeAll()
    }
    
    private func setUpURLRequest(url: URL?, header: [String: String]?) -> URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        
        if let header = header {
            header.forEach { (field, value) in
                urlRequest.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        return urlRequest
    }
}
