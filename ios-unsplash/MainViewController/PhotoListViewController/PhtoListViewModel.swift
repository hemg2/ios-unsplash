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
    @Published var isLoading: Bool = false
    @Published var onError: ((Error) -> Void)?
    var cancellables: Set<AnyCancellable> = []
    var pageNumber: Int = 0
    var isLastPage: Bool = false
    let category = ["Report/Editing", "Wallpaper", "Cool Tones", "Nature", "Travel", "Architecture and interiors", "Street Photography", "Film", "People"]
    
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
                
                self.isLastPage = newPhotos.isEmpty
            })
            .store(in: &self.cancellables)
    }
    
    func searchLoadPhotos(query: String, isRefresh: Bool = false) {
        guard !isLoading else { return }
        
        if isRefresh {
            pageNumber = 1
        } else {
            pageNumber += 1
        }
        
        isLoading = true
        
        repository.searchPhotos(query: query, page: pageNumber)
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
                    self.photos = newPhotos.results
                } else {
                    self.photos.append(contentsOf: newPhotos.results)
                }
                
                self.isLastPage = newPhotos.results.isEmpty
            })
            .store(in: &self.cancellables)
    }
}
