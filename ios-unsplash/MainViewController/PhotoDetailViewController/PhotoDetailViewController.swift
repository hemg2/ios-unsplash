//
//  PhotoDetailViewController.swift
//  ios-unsplash
//
//  Created by 1 on 2/10/24.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    
    var photo: Photo?
    private let photoDetailView = PhotoDetailView()
    
    override func loadView() { view = photoDetailView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "B"
        navigationItem.leftBarButtonItem?.title = "a"
        
        guard let photo else { return }
        photoDetailView.setupModel(photo: photo)
    }
}
