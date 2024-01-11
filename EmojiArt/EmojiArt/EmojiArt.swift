//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import Foundation

struct EmojiArt {
    private(set) var background: URL?
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    mutating func setBackground(_ url: URL?) {
        background = url
    }
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, of size: Int) {
        uniqueEmojiId += 1
        emojis.append(.init(
            emoji: emoji,
            position: position,
            size: size,
            id: uniqueEmojiId
        ))
    }
    
    struct Emoji: Identifiable {
        let emoji: String
        var position: Position
        var size: Int
        let id: Int
        
        struct Position {
            static let zero = Self(x: 0, y: 0)
            
            var x: Int
            var y: Int
        }
    }
}
