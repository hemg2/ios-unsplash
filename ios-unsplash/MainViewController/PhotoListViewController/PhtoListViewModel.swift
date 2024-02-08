//
//  PhtoListViewModel.swift
//  ios-unsplash
//
//  Created by 1 on 2/6/24.
//

import UIKit

final class PhotoListViewModel {
    private let repository: UnsplashRepository
    var photos: [Photo] = []
    var onPhotosUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(repository: UnsplashRepository) {
        self.repository = repository
    }
    
    func loadPhotos() {
        repository.fetchPhotos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self?.photos = photos
                    self?.onPhotosUpdate?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
}
