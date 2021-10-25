//
//  Song.swift
//  ItunesAlbums
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.10.2021.
//

import Foundation

struct SongResponse: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String?
}
