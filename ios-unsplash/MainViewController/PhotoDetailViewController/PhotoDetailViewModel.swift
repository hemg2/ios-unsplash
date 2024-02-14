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
    var cancellables: Set<AnyCancellable> = []

    init(photos: [Photo], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
    }

    func showNextPhoto() {
        guard currentIndex < photos.count else { return }
        currentIndex += 1
    }

    func showPreviousPhoto() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
}
