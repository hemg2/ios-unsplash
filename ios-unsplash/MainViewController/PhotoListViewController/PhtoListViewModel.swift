//
//  PhtoListViewModel.swift
//  ios-unsplash
//
//  Created by 1 on 2/6/24.
//

import UIKit
import Combine

final class PhotoListViewModel {
    private let repository: UnsplashRepository
    @Published var photos: [Photo] = []
    var cancellables: Set<AnyCancellable> = []
    
    var onPhotosUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(repository: UnsplashRepository) {
        self.repository = repository
    }
    
    func loadPhotos() {
        repository.fetchPhotos()
            .sink { completion in
                switch completion {
                case.failure(let error):
                    self.onError?(error)
                case .finished:
                    break
                }
            } receiveValue: { photos in
                self.photos = photos
            }
            .store(in: &cancellables)
    }
}
