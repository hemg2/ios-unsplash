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
    @Published var currentIndex: Int = 0 {
        didSet {
            updateCurrentPhotoURL()
        }
    }
    @Published var currentPhotoURL: URL?
    @Published var isUIElementsHidden: Bool = false
    @Published var isLoading: Bool = false

    init(photos: [Photo], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
        updateCurrentPhotoURL()
    }

    private func updateCurrentPhotoURL() {
        guard photos.indices.contains(currentIndex) else { return }
        currentPhotoURL = URL(string: photos[currentIndex].urls.small)
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
