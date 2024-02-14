//
//  PhotoDetailViewController.swift
//  ios-unsplash
//
//  Created by Hemg on 2/10/24.
//

import UIKit
import Combine

final class PhotoDetailViewController: UIViewController {
    
    var photo: Photo?
    private let photoDetailView = PhotoDetailView()
    private var viewModel: PhotoDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() { view = photoDetailView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNavigationBarUI()
        setupShareButton()
        setupTapGesture()
        setupSwipeGestures()
        setupViewModelBindings()
    }
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewModelBindings() {
        viewModel.$currentIndex
            .sink { [weak self] _ in
                self?.updatePhotoDetailView()
            }
            .store(in: &cancellables)

        viewModel.$currentPhotoURL
            .compactMap { $0 }
            .sink { [weak self] url in
                if let cancellable = self?.photoDetailView.loadImage(from: url) {
                    self?.cancellables.insert(cancellable)
                }
            }
            .store(in: &cancellables)

        viewModel.$isUIElementsHidden
            .sink { [weak self] isHidden in
                self?.photoDetailView.toggleUIElements(shouldHide: isHidden)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.photoDetailView.showLoadingIndicator()
                } else {
                    self?.photoDetailView.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    private func setupNavigationBarUI() {
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
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupSwipeGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToLeft(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToRight(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    private func updatePhotoDetailView() {
        let photo = viewModel.photos[viewModel.currentIndex]
        if let url = URL(string: photo.urls.small) {
            let cancellable = photoDetailView.loadImage(from: url)
            cancellables.insert(cancellable)
        }
        title = photo.user.name
    }
}

// MARK: Action
extension PhotoDetailViewController {
    @objc private func handleTap() {
        guard let navigationController = navigationController else { return }
        let shouldHide = navigationController.navigationBar.alpha == 1
        UIView.animate(withDuration: 0.25) {
            navigationController.navigationBar.alpha = shouldHide ? 0 : 1
            self.photoDetailView.toggleUIElements(shouldHide: shouldHide)
        }
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
}
