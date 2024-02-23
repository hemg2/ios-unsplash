//
//  PhotoListViewController.swift
//  ios-unsplash
//
//  Created by 1 on 2/5/24.
//

import UIKit
import Combine

final class PhotoListViewController: UIViewController {
    
    private let viewModel: PhotoListViewModel
    var cancellables: Set<AnyCancellable> = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let refreshAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.viewModel.loadPhotos(isRefresh: true)
        }
        
        refreshControl.addAction(refreshAction, for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["보도/편집", "배경 화면", "쿨 톤", "자연", "3D 렌더링", "여행하다", "건축 및 인테리어"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        
        let action = UIAction { [weak self] (action) in
            if let segment = action.sender as? UISegmentedControl {
                self?.segmentChanged(to: segment.selectedSegmentIndex)
            }
        }
        
        control.addAction(action, for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewModel()
        viewModel.loadPhotos()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Unsplash"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        
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
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoListCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.refreshControl = refreshControl
        
        collectionView.reloadData()
    }
    
    private func stopRefreshing() {
        self.refreshControl.endRefreshing()
        
        if self.activityIndicatorView.isAnimating {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.stopRefreshing()
            }
            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupSegmentedControl() {
        view.addSubview(scrollView)
        scrollView.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: segmentedControl.heightAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: scrollView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            segmentedControl.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func segmentChanged(to index: Int) {
        viewModel.loadPhotos()
        print("불리냐?")
    }
}

// MARK: UICollectionViewDataSource
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

// MARK: UICollectionViewDelegateFlowLayout
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let photo = viewModel.photos[safe: indexPath.row] else { return }
        guard let snapshot = self.view.snapshotView(afterScreenUpdates: true) else { return }
        let detailViewModel = PhotoDetailViewModel(photos: viewModel.photos, currentIndex: indexPath.row)
        let detailView = PhotoDetailViewController(viewModel: detailViewModel)
        detailView.backgroundSnapshotView = snapshot
        detailView.photo = photo
        detailView.title = photo.user.name
        detailView.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(detailView, animated: true)
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max(), !viewModel.isLoading else {
            return
        }
        
        if maxRow >= viewModel.photos.count - 1 {
            viewModel.loadPhotos()
        }
    }
}
