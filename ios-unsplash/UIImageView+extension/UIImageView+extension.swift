//
//  UIImageView+extension.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import UIKit
import Combine

extension UIImageView {
    func loadImage(from url: URL) -> AnyCancellable {
        let cache = URLCache()
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        let session = URLSession(configuration: configuration)
        
        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                if let response = cache.cachedResponse(for: URLRequest(url: url)) {
                    return response.data
                }
                return result.data
            }
            .compactMap(UIImage.init)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                self?.image = image
            })
    }
}
