//
//  PhotoDetailViewModel.swift
//  ios-unsplash
//
//  Created by 1 on 2/14/24.
//

import Foundation
import Combine

final class PhotoDetailViewModel {
    @Published var photos: [Photo]
    @Published var currentIndex: Int
    @Published var isUIElementsHidden: Bool = false
    init(photos: [Photo], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
    }
    
    func updatePhotos(index: Int) {
        guard photos.indices.contains(index) else { return }
        currentIndex = index
    }
    
    func toggleUIElementsVisibility() {
        isUIElementsHidden.toggle()
    }
}
