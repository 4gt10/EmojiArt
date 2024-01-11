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
    
    init() {
        model.addEmoji("＋", at: .zero, of: 40)
        model.addEmoji("🍎", at: .init(x: 200, y: 200), of: 40)
        model.addEmoji("🍑", at: .init(x: -200, y: 200), of: 60)
        model.addEmoji("🍊", at: .init(x: -200, y: -200), of: 80)
        model.addEmoji("🍐", at: .init(x: 200, y: -200), of: 100)
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        model.setBackground(url)
    }
    
    func addEmoji(_ emoji: String, at location: CGPoint, in geometry: GeometryProxy, of size: Int) {
        model.addEmoji(emoji, at: emojiPosition(at: location, in: geometry), of: size)
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return .init(x: Int(location.x - center.x), y: Int(center.y - location.y))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return .init(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
