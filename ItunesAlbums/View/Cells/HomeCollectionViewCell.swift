//
//  HomeCollectionViewCell.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
    private let albumImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let artistName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let albumName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(albumImage)
        self.addSubview(albumName)
        self.addSubview(artistName)
        
        NSLayoutConstraint.activate([
            albumImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            albumImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            albumImage.heightAnchor.constraint(equalToConstant: self.bounds.height / 1.5),
            albumImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            
            artistName.topAnchor.constraint(equalTo: albumImage.bottomAnchor, constant: 10),
            artistName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            artistName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            albumName.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 1),
            albumName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            albumName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        ])
    }
    
    func configureCell(model: Album) {
        albumImage.sd_setImage(with: URL(string: model.artworkUrl100), completed: nil)
        artistName.text = model.artistName
        albumName.text = model.collectionName
    }
}

//CANVAS
import SwiftUI

struct HomeCell_Provider: PreviewProvider {
    
    static var previews: some View {
        Container()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: HomeViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
