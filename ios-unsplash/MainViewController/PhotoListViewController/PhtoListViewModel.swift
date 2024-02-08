//
//  PhtoListViewModel.swift
//  ios-unsplash
//
//  Created by 1 on 2/6/24.
//

import UIKit

final class PhotoListViewModel {
    private var photos: [PhotoTest] = []
    
    var numberOfItems: Int {
        return photos.count
    }
    
    func loadPhotos() {
        photos = [PhotoTest(title: "1"), PhotoTest(title: "2"), PhotoTest(title: "3")]
    }
    
    func titleForItemAt(indexPath: IndexPath) -> String {
        return photos[indexPath.row].title
    }
}
