//
//  SearchViewController.swift
//  ios-unsplash
//
//  Created by Hemg on 2/5/24.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State private var searchText = ""
    private var viewModel: CategoriesViewModel
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding()
                    .background(Color.black)
                    .onChange(of: searchText) { newValue in
                        viewModel.searchPhotos(query: newValue)
                    }
                ScrollView {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        Text("범주별 찾아보기")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        CategoriesView(searchText: $searchText, viewModel: viewModel)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .environment(\.colorScheme, .dark)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("사진, 컬렉션, 사용자 검색", text: $text)
                .foregroundColor(.primary)
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill").opacity(text == "" ? 0 : 1)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.secondary)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
    }
}

struct CategoriesView: View {
    @Binding var searchText: String
    let viewModel: CategoriesViewModel
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(searchText.isEmpty ? viewModel.categories : viewModel.searchCategories, id: \.self) { category in
                    NavigationLink(destination: CategoryDetailView(category: category, repository: viewModel.repository)) {
                        ZStack {
                            if let imageUrl = category.imageUrl {
                                AsyncImage(url: imageUrl) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                                }
                            } else {
                                Color.gray.opacity(0.3)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                            }
                            Text(category.name)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                                .background(Color.black.opacity(0.3))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: CategoriesViewModel(repository: UnsplashRepositoryImplementation(sessionProvider: URLSessionProviderImplementation())))
    }
}
