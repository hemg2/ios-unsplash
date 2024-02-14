//
//  PhotoDetaillViewCell.swift
//  ios-unsplash
//
//  Created by 1 on 2/14/24.
//

import UIKit
import Combine

final class PhotoDetaillViewCell: UICollectionViewCell {
    
    private var cancellable: AnyCancellable?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContents()
        setupContentViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        cancellable?.cancel()
        loadingIndicator.stopAnimating()
        likeButton.isSelected = false
    }
    
    private func setupContents() {
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(photoImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(addButton)
        contentView.addSubview(downloadButton)
    }
    
    private func setupContentViewLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            addButton.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: -20),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            downloadButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension PhotoDetaillViewCell {
    func configure(photo: Photo) {
        loadingIndicator.startAnimating()
        if let photoURL = URL(string: photo.urls.small) {
            cancellable = photoImageView.loadImage(from: photoURL)
            loadingIndicator.stopAnimating()
        }
    }
    
    func toggleUIElements(shouldHide: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.likeButton.alpha = shouldHide ? 0 : 1
            self.addButton.alpha = shouldHide ? 0 : 1
            self.downloadButton.alpha = shouldHide ? 0 : 1
        }
    }
    
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
        }
    }
}
