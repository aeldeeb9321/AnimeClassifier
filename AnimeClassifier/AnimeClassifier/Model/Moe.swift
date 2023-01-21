//
//  Moe.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import Foundation

struct Moe: Codable {
    let result: [Anime]
}

struct Anime: Codable {
    let fileName: String
    let episode: Int
    let from: TimeInterval
    let to: TimeInterval
    let similarity: Float
    let videoUrlString: String
    let imageUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case episode, similarity, from, to
        case fileName = "filename"
        case videoUrlString = "video"
        case imageUrlString = "image"
    }
}
