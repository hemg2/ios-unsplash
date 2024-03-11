//
//  ViewController.swift
//  ios-unsplash
//
//  Created by 1 on 2/4/24.
//

import UIKit
import SwiftUI

final class MainViewController: UITabBarController {
    let viewModel: PhotoListViewModel
    let categoriViewModel: CategoriesViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        setupTabbarLayout()
        setupTabbarConfigureUI()
    }
    
    init(viewModel: PhotoListViewModel, categoriViewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        self.categoriViewModel = categoriViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViewController() {
        view.backgroundColor = .black
    }
    
    private func setupTabbarLayout() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        tabBar.tintColor = .white
        
        tabBar.standardAppearance = appearance
    }
    
    private func setupTabbarConfigureUI() {
        let photoVC = PhotoListViewController(viewModel: viewModel)
        let photoNavVC = UINavigationController(rootViewController: photoVC)
        photoNavVC.tabBarItem = UITabBarItem(title: "",
                                             image: UIImage(systemName: "photo"),
                                             selectedImage: UIImage(systemName: "photo.fill"))
        
        let searchVC = UIHostingController(rootView: SearchView(viewModel: categoriViewModel))
        searchVC.tabBarItem = UITabBarItem(title: "",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        viewControllers = [photoNavVC, searchVC]
    }
    
}
