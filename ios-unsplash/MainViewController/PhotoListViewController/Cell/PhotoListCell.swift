//
//  PhotoListCell.swift
//  ios-unsplash
//
//  Created by 1 on 2/6/24.
//

import UIKit
import Combine

final class PhotoListCell: UICollectionViewCell {
    
    private var cancellable: AnyCancellable?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let photoImageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.shadowColor = .black
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentUI()
        setupContentLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        cancellable?.cancel()
        photoImageLabel.text = nil
        loadingIndicator.stopAnimating()
    }
    
    private func setupContentUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(photoImageLabel)
        contentView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadingIndicator.center = contentView.center
    }
    
    private func setupContentLayout() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            photoImageLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 10),
            photoImageLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -10),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }
    
    func setupModel(photo: Photo) {
        loadingIndicator.startAnimating()
        if let photoURL = URL(string: photo.urls.small) {
            cancellable = photoImageView.loadImage(from: photoURL)
            self.photoImageLabel.text = photo.user.name
            loadingIndicator.stopAnimating()
        }
    }
}
