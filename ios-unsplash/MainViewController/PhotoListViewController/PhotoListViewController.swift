//
//  PhotoListViewController.swift
//  ios-unsplash
//
//  Created by 1 on 2/5/24.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    private let viewModel: PhotoListViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNavigationBar()
        setupCollectionView()
        bindViewModel()
        viewModel.loadPhotos()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Unsplash"
        
        let image = UIImage(systemName: "camera")
        let cameraAction = UIAction(title: "", image: image) { action in
            // 버튼 액션
        }
        
        let cameraButton = UIBarButtonItem(primaryAction: cameraAction)
        navigationItem.leftBarButtonItem = cameraButton
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoListCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.reloadData()
    }
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoListCell,
              let photo = viewModel.photos[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.setupModel(photo: photo)
        return cell
    }
}

extension PhotoListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = viewModel.photos[safe: indexPath.row] else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = collectionView.bounds.width
        let photoAspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let height = width * photoAspectRatio
        
        return CGSize(width: width, height: height)
    }
}
