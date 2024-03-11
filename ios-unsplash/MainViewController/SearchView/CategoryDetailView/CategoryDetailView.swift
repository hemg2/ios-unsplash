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
            if viewModel.isLoading {
                ProgressView()
            } else {
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
        }
        .onAppear {
            viewModel.loadPhotos(query: category.name)
        }
        .navigationTitle(category.name)
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //        CategoryDetailView(category: CategoryItem(name: "자연"), repository: UnsplashRepositoryImplementation(sessionProvider: URLSessionProviderImplementation()))
        CategoryDetailView(category: CategoryItem(name: "하늘"), repository: UnsplashRepositoryImplementation(sessionProvider: URLSessionProviderImplementation()))
    }
}
