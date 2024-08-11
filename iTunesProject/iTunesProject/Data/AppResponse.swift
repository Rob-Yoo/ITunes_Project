//
//  AppDTO.swift
//  iTunesProject
//
//  Created by Jinyoung Yoo on 8/8/24.
//

import Foundation

struct AppResponse: Decodable {
    let resultCount: Int
    let results: [App]
}

struct App: Decodable {
    let appIcon: String
    let appName: String
    let developerName: String
    let version: String
    let description: String
    let releaseNotes: String?
    
    enum CodingKeys: String, CodingKey {
        case appIcon = "artworkUrl100"
        case appName = "trackName"
        case developerName = "artistName"
        case version
        case description
        case releaseNotes
    }
}
