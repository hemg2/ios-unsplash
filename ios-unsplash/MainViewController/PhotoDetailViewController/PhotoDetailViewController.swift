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
    private var viewModel: PhotoDetailViewModel
    
    override func loadView() { view = photoDetailView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        navigationBarImteUI()
        setupShareButton()
        setModel()
        setupTapGesture()
        setupBindings()
        setupSwipeGestures()
    }
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupBindings() {
        viewModel.$currentIndex
            .sink { [weak self] _ in
                self?.updatePhotoDetailView()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupSwipeGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToLeft(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToRight(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc private func handleSwipeToLeft(_ gesture: UISwipeGestureRecognizer) {
        
        let newFrame = photoDetailView.frame.offsetBy(dx: -view.frame.width, dy: 0)
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.photoDetailView.frame = newFrame
            self?.viewModel.showNextPhoto()
            self?.photoDetailView.showLoadingIndicator()
        }) { _ in
            self.photoDetailView.frame = self.view.bounds
            self.updatePhotoDetailView()
            self.photoDetailView.hideLoadingIndicator()
        }
    }
    
    @objc private func handleSwipeToRight(_ gesture: UISwipeGestureRecognizer) {
        let newFrame = photoDetailView.frame.offsetBy(dx: view.frame.width, dy: 0)
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.photoDetailView.frame = newFrame
            self?.viewModel.showPreviousPhoto()
            self?.photoDetailView.showLoadingIndicator()
        }) { _ in
            self.photoDetailView.frame = self.view.bounds
            self.updatePhotoDetailView()
            self.photoDetailView.hideLoadingIndicator()
        }
    }
    
    private func updatePhotoDetailView() {
        let photo = viewModel.photos[viewModel.currentIndex]
        photoDetailView.setupModel(photo: photo)
        title = photo.user.name
    }
}
