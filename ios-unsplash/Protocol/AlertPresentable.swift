//
//  AlertPresentable.swift
//  ios-unsplash
//
//  Created by Hemg on 2/28/24.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String, message: String, completion: (() -> Void)?)
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
