//
//  CategoryDetailViewModel.swift
//  ios-unsplash
//
//  Created by Hemg on 3/11/24.
//

import Foundation
import Combine

protocol CategoryDetailViewModelInput {
    func loadPhotos(query: String)
}

protocol CategoryDetailViewModelOutput {
    var photos: [Photo] { get }
    var isLoading: Bool { get }
}

final class CategoryDetailViewModel: ObservableObject, CategoryDetailViewModelInput, CategoryDetailViewModelOutput {
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    private var cancellables: Set<AnyCancellable> = []
    private let repository: UnsplashRepository
    
    init(repository: UnsplashRepository) {
        self.repository = repository
    }
    
    func loadPhotos(query: String) {
        isLoading = true
        repository.searchPhotos(query: query, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("\(error.localizedDescription)")
                case .finished:
                    print("photos")
                }
            }, receiveValue: { [weak self] response in
                self?.photos = response.results
            })
            .store(in: &cancellables)
    }
}
