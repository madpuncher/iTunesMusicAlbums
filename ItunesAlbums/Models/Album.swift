//
//  Album.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//

import Foundation

struct AlbumResponse: Decodable {
    let results: [Album]
}

struct Album: Decodable, Comparable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let trackCount: Int
    let releaseDate: String
    let collectionId: Int
    
    static func <(lhs: Album, rhs: Album) -> Bool {
        return lhs.collectionName < rhs.collectionName
    }
}
