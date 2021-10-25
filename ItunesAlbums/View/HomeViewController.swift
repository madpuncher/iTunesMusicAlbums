//
//  ViewController.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Constants
    let views = HomeViews()
    
    private lazy var collectionView = views.collectionView
    private lazy var emptyLabel = views.emptyLabel
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var timer: Timer?
    
    var albums = [Album]() {
        didSet {
            albums.sort(by: <)
        }
    }
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        searchController.searchBar.delegate = self
        setupNavBar()
        setupConstraints()
        
        if !NetworkManager.shared.isConnectedToNetwork() {
            unableConnect()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyLabel.center = view.center
    }
    
    
    //MARK: CHECK NETWORK STATE
    func unableConnect() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Ошибка",
                                          message: "Отсутствует подключение к интернету",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: VIEW SETUP
    private func setupNavBar() {
        title = "Альбомы"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupConstraints() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3),
        ])
    }
    
    ///Update label if array is empty or search was failing
    private func dataCheckerForLabel(searchText: String) {
        if !albums.isEmpty {
            emptyLabel.isHidden = true
        } else if !searchText.isEmpty && albums.isEmpty {
            emptyLabel.text = "Мы ничего не нашли..."
            emptyLabel.isHidden = false
        } else {
            emptyLabel.text = "Для того, что бы найти альбом, необходимо ввести название в строку поиска"
            emptyLabel.isHidden = false
        }
    }
}

//MARK: DATA SOURCE AND DELEGATE FOR COLLECTION VIEW
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.configureCell(model: albums[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.3, height: collectionView.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !NetworkManager.shared.isConnectedToNetwork() {
            unableConnect()
        } else {
            let detailsVC = DetailsViewController()
            let album = albums[indexPath.item]
            detailsVC.title = album.collectionName
            detailsVC.album = album
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
}

//MARK: SEARCH BAR DELEGATE
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            NetworkManager.shared.fetchData(searchText: searchText) { [weak self] responseData in
                guard let responseDataAlbums = responseData else { return }
                
                DispatchQueue.main.async {
                    self?.albums = responseDataAlbums
                    self?.collectionView.reloadData()
                    
                    self?.dataCheckerForLabel(searchText: searchText)
                }
            }
        })
    }
}

//MARK: CANVAS
import SwiftUI

struct HomeVC_Provider: PreviewProvider {
    
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
