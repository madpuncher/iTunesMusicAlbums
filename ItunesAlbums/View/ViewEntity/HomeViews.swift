//
//  HomeViews.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//

import UIKit  

final class HomeViews {
    
    public let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    public let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Для того, что бы найти альбом, необходимо ввести название в строку поиска"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
