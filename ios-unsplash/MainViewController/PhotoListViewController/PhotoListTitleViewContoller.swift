//
//  PhotoListTitleViewContoller.swift
//  ios-unsplash
//
//  Created by Hemg on 2/26/24.
//

import UIKit

protocol PhotoListTitleViewControllerDelegate: AnyObject {
    func categoryDidSelect(at index: Int)
}

final class PhotoListTitleViewContoller: UIViewController {
    
    private let viewModel: PhotoListViewModel
    weak var delegate: PhotoListTitleViewControllerDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        
        return scrollView
    }()
    
    private var buttons = [UIButton]()
    private let items = ["보도/편집", "배경 화면", "쿨 톤", "자연", "3D 렌더링", "여행하다", "건축 및 인테리어"]
    
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
        setupCategoryButtons()
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCategoryButtons() {
        var previousButton: UIButton?
        
        items.enumerated().forEach { index, category in
            let action = UIAction(title: category, handler: { [weak self] _ in
                self?.delegate?.categoryDidSelect(at: index)
            })
            
            let button = UIButton(type: .system, primaryAction: action)
            button.tag = index
            button.setTitle(category, for: .normal)
            button.tintColor = .white
            
            scrollView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: scrollView.topAnchor),
                button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                button.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            
            if let previousButton = previousButton {
                button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 12).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
            }
            
            previousButton = button
            buttons.append(button)
        }
        
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20)
            ])
        }
    }
    
    func scrollToButton(at index: Int) {
        let button = buttons[index]
        var offset = button.center.x - scrollView.bounds.size.width / 2
        
        offset = max(min(offset, scrollView.contentSize.width - scrollView.bounds.size.width), 0)
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }

    func highlightButton(at index: Int) {
        buttons.forEach { button in
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.backgroundColor = .clear
        }
        
        let button = buttons[index]
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .clear
    }
}
