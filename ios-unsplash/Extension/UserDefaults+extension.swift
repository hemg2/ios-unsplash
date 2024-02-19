//
//  UserDefaults+extension.swift
//  ios-unsplash
//
//  Created by 1 on 2/19/24.
//

import Foundation

extension UserDefaults {
    func setLikedState(_ isLiked: Bool, _ photoId: String) {
        set(isLiked, forKey: photoId)
    }
    func isLiked(photoId: String) -> Bool {
        bool(forKey: photoId)
    }
}
