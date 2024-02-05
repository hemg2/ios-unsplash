//
//  ViewController.swift
//  ios-unsplash
//
//  Created by 1 on 2/4/24.
//

import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        setupTabbarLayout()
        setupTabbarConfigureUI()
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupTabbarLayout() {
        tabBar.barTintColor = .black
    }
    
    private func setupTabbarConfigureUI() {
        let photoVC = PhotoListViewController()
        photoVC.tabBarItem = UITabBarItem(title: "",
                                          image: UIImage(systemName: "photo"),
                                          selectedImage: UIImage(systemName: "photo.fill"))
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "",
                                          image: UIImage(systemName: "magnifyingglass"),
                                          selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        viewControllers = [photoVC, searchVC]
    }
    
}
