//
//  ViewController.swift
//  ios-unsplash
//
//  Created by 1 on 2/4/24.
//

import UIKit

final class MainViewController: UITabBarController {
    let viewModel: PhotoListViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        setupTabbarLayout()
        setupTabbarConfigureUI()
    }
    
    init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupTabbarLayout() {
        tabBar.tintColor = .black
    }
    
    private func setupTabbarConfigureUI() {
        let photoVC = PhotoListViewController(viewModel: viewModel)
        let photoNavVC = UINavigationController(rootViewController: photoVC)
        photoNavVC.tabBarItem = UITabBarItem(title: "",
                                          image: UIImage(systemName: "photo"),
                                          selectedImage: UIImage(systemName: "photo.fill"))
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "",
                                          image: UIImage(systemName: "magnifyingglass"),
                                          selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        viewControllers = [photoNavVC, searchVC]
    }
    
}
