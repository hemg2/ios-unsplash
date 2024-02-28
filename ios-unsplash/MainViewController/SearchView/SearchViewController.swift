//
//  SearchViewController.swift
//  ios-unsplash
//
//  Created by Hemg on 2/5/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

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
                        CategoriesView()
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

struct CategoryItem {
    var naem: String
    var imageName: String
}

struct CategoriesView: View {
    let categories: [CategoryItem] = [
        CategoryItem(naem: "자연", imageName: "nature"),
        CategoryItem(naem: "흑백", imageName: "nature"),
        CategoryItem(naem: "우주", imageName: "nature"),
        CategoryItem(naem: "텍스처", imageName: "nature"),
        CategoryItem(naem: "추상적", imageName: "nature"),
        CategoryItem(naem: "미니멀", imageName: "nature"),
    ]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<categories.count, id: \.self) { index in
                    ZStack {
                        Image(categories[index].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                        Text(categories[index].naem)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
