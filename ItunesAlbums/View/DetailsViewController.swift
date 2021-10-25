//
//  DetailsViewController.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    //MARK: CONSTANTS
    
    private let views = DetailsViews()
    
    private lazy var tableView = views.tableView
    private lazy var albumImage = views.albumImage
    private lazy var artistName = views.artistName
    private lazy var releaseDate = views.releaseDate
    private lazy var trackCount = views.trackCount

    public var album: Album?
    private var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        configureData()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        albumImage.widthAnchor.constraint(equalToConstant: albumImage.bounds.height).isActive = true
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        
        view.addSubview(albumImage)
        
        let stackView = UIStackView(arrangedSubviews: [artistName, releaseDate, trackCount])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
           
            albumImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            albumImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImage.heightAnchor.constraint(equalToConstant: view.bounds.height / 4),
            
            stackView.topAnchor.constraint(equalTo: albumImage.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureData() {
        guard let albumData = album else { return }
        artistName.text = "Исполнитель: \(albumData.artistName)"
        releaseDate.text = "Дата выхода: \(configureDate(date: albumData.releaseDate))"
        trackCount.text = "Количество треков: \(albumData.trackCount)"
        albumImage.sd_setImage(with: URL(string: albumData.artworkUrl100), completed: nil)
        
        NetworkManager.shared.fetchSong(albumId: "\(albumData.collectionId)") { songs in
            guard let songData = songs else { return }
            
            DispatchQueue.main.async {
                self.songs = songData
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureDate(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let dateWasFormate = dateFormatter.date(from: date) else { return "Ошибка"}
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let dateReturn = formatDate.string(from: dateWasFormate)
        return dateReturn
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}

//MARK: TABLE VIEW DELEGATE AND DATA SOURCE
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = songs[indexPath.row].trackName ?? "Все треки:"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: CANVAS
import SwiftUI

struct DetailsVC_Provider: PreviewProvider {
    
    static var previews: some View {
        Container()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: DetailsViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
