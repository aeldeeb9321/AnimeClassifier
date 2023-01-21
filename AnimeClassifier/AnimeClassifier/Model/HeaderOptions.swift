//
//  HeaderOptions.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import Foundation

enum HeaderOptions: Int, CustomStringConvertible, CaseIterable {
    case imageScene
    case videoScene
    
    var description: String {
        switch self {
        case .imageScene:
            return "Possible Image Scenes"
        case .videoScene:
            return "Possible Video Scenes"
        }
    }
    
}
