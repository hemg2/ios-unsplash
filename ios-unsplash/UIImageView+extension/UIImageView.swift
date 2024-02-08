//
//  UIImageView.swift
//  ios-unsplash
//
//  Created by 1 on 2/8/24.
//

import UIKit
import Combine

//extension UIImageView {
//    func loadImage(from url: URL) -> AnyCancellable {
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { UIImage(data: $0.data) }
//            .replaceError(with: nil)
//            .receive(on: RunLoop.main)
//            .sink { [weak self] in self?.image = $0 }
//    }
//}
extension UIImageView {
    func loadImage(from url: URL) -> AnyCancellable {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap(UIImage.init)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                self?.image = image
            })
    }
}

