//
//  CategoryDetailView.swift
//  ios-unsplash
//
//  Created by Hemg on 3/5/24.
//

import SwiftUI
import Combine

struct CategoryDetailView: View {
    private let category: CategoryItem
    @ObservedObject private var viewModel: CategoryDetailViewModel
    
    init(category: CategoryItem, repository: UnsplashRepository) {
        self.category = category
        viewModel = CategoryDetailViewModel(repository: repository)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.photos, id: \.id) { photo in
                AsyncImage(url: URL(string: photo.urls.small)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .aspectRatio(contentMode: .fill)
                }
                .clipped()
                .cornerRadius(10)
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            viewModel.loadPhotos(query: category.name)
        }
        .navigationTitle(category.name)
    }
}


final class CategoryDetailViewModel: ObservableObject {
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
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
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
