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
    var viewModel: CategoriesViewModel
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding()
                    .background(Color.black)
                ScrollView {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        Text("범주별 찾아보기")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        CategoriesView(viewModel: viewModel)
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
    var viewModel: CategoriesViewModel
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<viewModel.categories.count, id: \.self) { index in
                    let category = viewModel.categories[index]
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
                    .onAppear() {
                        if category.imageUrl == nil {
                            viewModel.loadImage(for: category.name, at: index)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryItem {
    var name: String
    var imageUrl: URL?
}

final class CategoriesViewModel: ObservableObject {
    @Published var categories: [CategoryItem] = []
    private var cancellables: Set<AnyCancellable> = []
    private let repository: UnsplashRepository
    
    init(repository: UnsplashRepository) {
        self.repository = repository
        self.initializeCategories()
    }
    
    private func initializeCategories() {
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: CategoriesViewModel(repository: UnsplashRepositoryImplementation(sessionProvider: URLSessionProviderImplementation())))
    }
}
