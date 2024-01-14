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
    
    mutating func updateEmoji(id: Emoji.ID, size: Int) {
        guard let index = emojiIndex(with: id) else {
            return
        }
        emojis[index].size = size
    }
    
    mutating func updateEmoji(id: Emoji.ID, position: Emoji.Position) {
        guard let index = emojiIndex(with: id) else {
            return
        }
        emojis[index].position = position
    }
    
    
}

// MARK: - Private methods

private extension EmojiArt {
    func emojiIndex(with id: Emoji.ID) -> Int? {
        guard let index = emojis.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return index
    }
}

// MARK: - Sub-entities

extension EmojiArt {
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
