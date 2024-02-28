//
//  ShareDisplayable.swift
//  ios-unsplash
//
//  Created by Hemg on 2/16/24.
//

import UIKit

protocol ShareDisplayable: AnyObject {
    func sharePhto(_ photo: Photo)
}

extension ShareDisplayable where Self: UIViewController {
    func sharePhto(_ photo: Photo) {
        guard let url = URL(string: photo.urls.small) else { return }
               let text = "Photo by \(photo.user.name) on Unsplash"
               let activityItems: [Any] = [text, url]

        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
