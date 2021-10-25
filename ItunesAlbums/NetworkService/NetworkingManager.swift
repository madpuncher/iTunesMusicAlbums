//
//  NetworkingManager.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//


import Foundation
import SystemConfiguration

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private struct Constants {
        
        static let url = "https://itunes.apple.com/search"
        static let urlSong = "https://itunes.apple.com/lookup"
    }
    
    ///Check connectiont state
    public func isConnectedToNetwork() -> Bool {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        guard let defaultReach = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultReach, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReach = flags.contains(.reachable)
        let connect = flags.contains(.connectionRequired)
        
        return (isReach && !connect)
    }
    
    public func fetchData(searchText: String, completion: @escaping ([Album]?) -> Void) {
        
        guard var url = URLComponents(string: Constants.url) else { return }
        
        url.queryItems = [URLQueryItem(name: "term", value: "\(searchText)"),
                          URLQueryItem(name: "entity", value: "album"),
        ]
        
        guard let finalURL = url.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    return
                }
            
            do {
                
                let result = try JSONDecoder().decode(AlbumResponse.self, from: data)
                completion(result.results)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    public func fetchSong(albumId: String, completion: @escaping ([Song]?) -> Void) {
        
        guard var url = URLComponents(string: Constants.urlSong) else { return }
        
        url.queryItems = [URLQueryItem(name: "id", value: "\(albumId)"),
                          URLQueryItem(name: "entity", value: "song"),
        ]
        
        guard let finalURL = url.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    return
                }
            
            do {
                
                let result = try JSONDecoder().decode(SongResponse.self, from: data)
                completion(result.results)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
}


