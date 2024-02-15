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
    private var viewModel: PhotoDetailViewModel
    var cancellables: Set<AnyCancellable> = []
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
        setupNavigationBarUI()
        setupShareButton()
        scrollToSelectedPhoto()
        setupTapGesture()
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.scrollToSelectedPhoto()
            }
            .store(in: &cancellables)
        viewModel.$isUIElementsHidden
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHidden in
                self?.updateUIVisibility(shouldHide: isHidden)
            }
            .store(in: &cancellables)
    }
}

// MARK: Action
extension PhotoDetailViewController {
    @objc private func handleTap() {
        viewModel.toggleUIElementsVisibility()
        updateUIVisibility(shouldHide: viewModel.isUIElementsHidden)
    }
    
    private func updateUIVisibility(shouldHide: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.navigationBar.alpha = shouldHide ? 0 : 1
            self.collectionView.visibleCells.forEach { cell in
                if let photoCell = cell as? PhotoDetaillViewCell {
                    photoCell.toggleUIElements(shouldHide: shouldHide)
                }
            }
        }
    }
    
    private func scrollToSelectedPhoto() {
        guard viewModel.photos.indices.contains(viewModel.currentIndex) else { return }
        let selectedIndexPath = IndexPath(item: viewModel.currentIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func updateTitleBasedOnVisibleCell() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        viewModel.currentIndex = visibleIndexPath.row
        let photo = viewModel.photos[visibleIndexPath.row]
        title = photo.user.name
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
        
        cell.configure(photo: photo, isUIElementsHidden: viewModel.isUIElementsHidden)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateTitleBasedOnVisibleCell()
    }
}
