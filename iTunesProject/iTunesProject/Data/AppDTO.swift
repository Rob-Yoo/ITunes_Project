//
//  AppDTO.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/8/24.
//

import Foundation

struct AppResponseDTO: Decodable {
    let resultCount: Int
    let results: [AppDTO]
}

struct AppDTO: Decodable {
    let appIcon: String
    let appName: String
    let developerName: String
    let version: String
    let description: String
    let releaseNotes: String
    
    enum CodingKeys: String, CodingKey {
        case appIcon = "artworkUrl100"
        case appName = "trackName"
        case developerName = "artistName"
        case version
        case description
        case releaseNotes
    }
}
