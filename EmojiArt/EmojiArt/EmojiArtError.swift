//
//  EmojiArtError.swift
//  EmojiArt
//
//  Created by 4gt10 on 29.01.2024.
//

import Foundation

enum EmojiArtError: Error {
    case fileNotFound
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "Emoji Art Error: File not found!"
        }
    }
}
