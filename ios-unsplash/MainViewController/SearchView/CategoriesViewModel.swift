//
//  CategoriesViewModel.swift
//  ios-unsplash
//
//  Created by Hemg on 3/11/24.
//

import Foundation
import Combine

protocol CategoriesViewModelInput {
    func initializeCategories()
    func loadImage(for query: String, at index: Int)
    func searchPhotos(query: String)
}

protocol CategoriesViewModelOutput {
    var categories: [CategoryItem] { get }
    var searchCategories: [CategoryItem] { get }
}

struct CategoryItem: Hashable {
    let id = UUID()
    var name: String
    var imageUrl: URL?
}

final class CategoriesViewModel: CategoriesViewModelInput, CategoriesViewModelOutput {
    @Published var categories: [CategoryItem] = []
    @Published var searchCategories: [CategoryItem] = []
    private var cancellables: Set<AnyCancellable> = []
    let repository: UnsplashRepository
    
    init(repository: UnsplashRepository) {
        self.repository = repository
        self.initializeCategories()
    }
    
    func initializeCategories() {
        categories = [
            CategoryItem(name: "자연"),
            CategoryItem(name: "흑백"),
            CategoryItem(name: "강아지"),
            CategoryItem(name: "고양이"),
            CategoryItem(name: "바다"),
            CategoryItem(name: "하늘")
        ]
        
        for index in categories.indices {
            loadImage(for: categories[index].name, at: index)
        }
    }
    
    func loadImage(for query: String, at index: Int) {
        guard let url = UnsplashEndPoint().searchURL(query: query, pageNumber: 1) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self,
                      let urlString = response.results.first?.urls.small,
                      let url = URL(string: urlString) else { return }
                self.categories[index].imageUrl = url
            })
            .store(in: &cancellables)
    }
    
    func searchPhotos(query: String) {
        if query.isEmpty {
            DispatchQueue.main.async {
                self.searchCategories = self.categories
            }
        } else {
            repository.searchPhotos(query: query, page: 1)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] response in
                    DispatchQueue.main.async {
                        self?.searchCategories = response.results.map { photo in
                            CategoryItem(name: photo.description ?? "", imageUrl: URL(string: photo.urls.small))
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
}
