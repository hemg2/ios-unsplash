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
    var pageNumber: Int = 0
    var isLoading: Bool = false
    var isLastPage: Bool = false
    var onError: ((Error) -> Void)?
    
    init(repository: UnsplashRepository) {
        self.repository = repository
    }
    
    func loadPhotos(isRefresh: Bool = false) {
        guard !isLoading else { return }
        
        if isRefresh {
            pageNumber = 1
        } else {
            pageNumber += 1
        }
        
        isLoading = true
        
        repository.fetchPhotos(page: pageNumber)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure(let error):
                    self.onError?(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] newPhotos in
                guard let self = self else { return }
                
                if isRefresh {
                    self.photos = newPhotos
                } else {
                    self.photos.append(contentsOf: newPhotos)
                }
                
                if newPhotos.isEmpty {
                    self.isLastPage = true
                } else {
                    self.pageNumber += 1
                }
            })
            .store(in: &self.cancellables)
    }
}
