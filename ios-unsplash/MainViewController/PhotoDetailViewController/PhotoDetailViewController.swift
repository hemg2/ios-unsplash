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
        navigationBarImteUI()
        setModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    private func navigationBarImteUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func setModel() {
        guard let photo else { return }
        photoDetailView.setupModel(photo: photo)
    }
}
