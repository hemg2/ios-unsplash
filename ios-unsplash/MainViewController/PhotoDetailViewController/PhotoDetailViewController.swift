//
//  PhotoDetailViewController.swift
//  ios-unsplash
//
//  Created by Hemg on 2/10/24.
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
        setupShareButton()
        setModel()
        setupTapGesture()
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
    
    private func setupShareButton() {
        let image = UIImage(systemName: "square.and.arrow.up")
        let shareAction = UIAction(title: "", image: image) { action in
            // 버튼 액션
        }
        
        let shareButton = UIBarButtonItem(primaryAction: shareAction)
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func setModel() {
        guard let photo else { return }
        photoDetailView.setupModel(photo: photo)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        guard let navigationController = navigationController else { return }
        let shouldHide = navigationController.navigationBar.alpha == 1
        UIView.animate(withDuration: 0.25) {
            navigationController.navigationBar.alpha = shouldHide ? 0 : 1
            self.photoDetailView.toggleUIElements(shouldHide: shouldHide)
        }
    }
}
