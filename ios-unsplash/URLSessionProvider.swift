//
//  URLSessionProvider.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation

protocol URLSessionProvider {
    func requestData(url: URL?, header: [String: String]?,  completionHandler: @escaping (Result<Data, APIError>) -> Void)
}

final class URLSessionProviderImplementation: URLSessionProvider {
    private var dataTasks: [URL: URLSessionDataTask] = [:]
    
    func requestData(url: URL?, header: [String: String]?,  completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = url, let urlRequest  = setUpURLRequest(url: url, header: header) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            defer {
                self?.dataTasks.removeValue(forKey: url)
            }
            
            if error != nil {
                completionHandler(.failure(.requestFail))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
                completionHandler(.failure(.invalidHTTPStatusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        
        dataTasks[url] = dataTask
        dataTask.resume()
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
