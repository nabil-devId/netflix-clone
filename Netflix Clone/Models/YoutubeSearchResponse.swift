//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Ahmad Nabil on 26/05/24.
//

import Foundation

struct YoutubeSearchResults: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
