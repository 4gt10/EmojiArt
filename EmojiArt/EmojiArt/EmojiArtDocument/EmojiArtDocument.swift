//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import SwiftUI

final class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var model: EmojiArt = EmojiArt()
    
    var background: URL? {
        model.background
    }
    
    var emojis: [Emoji] {
        model.emojis
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        model.setBackground(url)
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, of size: Int) {
        model.addEmoji(emoji, at: position, of: size)
    }
    
    func updateEmoji(with id: Emoji.ID, _ update: Emoji.Update) {
        model.updateEmoji(with: id, update)
    }
    
    func removeEmoji(with ids: [Emoji.ID]) {
        model.removeEmoji(with: ids)
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return .init(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
