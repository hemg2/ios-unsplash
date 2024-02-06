//
//  PhtoListViewModel.swift
//  ios-unsplash
//
//  Created by 1 on 2/6/24.
//

import UIKit

final class PhotoListViewModel {
    private var photos: [Photo] = []
    
    var numberOfItems: Int {
        return photos.count
    }
    
    func loadPhotos() {
        photos = [Photo(title: "1"), Photo(title: "2"), Photo(title: "3")]
    }
    
    func titleForItemAt(indexPath: IndexPath) -> String {
        return photos[indexPath.row].title
    }
}
