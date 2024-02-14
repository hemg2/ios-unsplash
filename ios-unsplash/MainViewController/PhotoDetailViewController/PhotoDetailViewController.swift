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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        
        return collectionView
    }()
    
//    override func loadView() { view = photoDetailView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
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
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoDetaillViewCell.self, forCellWithReuseIdentifier: "Detailcell")
        
        collectionView.reloadData()
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
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.photoDetailView.frame = newFrame
            self?.viewModel.showNextPhoto()
        }) { _ in
            self.photoDetailView.frame = self.view.bounds
        }
    }
    
    @objc private func handleSwipeToRight(_ gesture: UISwipeGestureRecognizer) {
        let newFrame = photoDetailView.frame.offsetBy(dx: view.frame.width, dy: 0)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.photoDetailView.frame = newFrame
            self?.viewModel.showPreviousPhoto()
        }) { _ in
            self.photoDetailView.frame = self.view.bounds
        }
    }
}

// MARK: UICollectionViewDataSource
extension PhotoDetailViewController: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detailcell", for: indexPath) as? PhotoDetaillViewCell,
              let photo = viewModel.photos[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(photo: photo)
        return cell
    }
}

extension PhotoDetailViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let photo = viewModel.photos[indexPath.item]
        }
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
