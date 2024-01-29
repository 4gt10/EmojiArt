//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import SwiftUI

final class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var model: EmojiArt = EmojiArt() {
        didSet {
            persist()
        }
    }
    
    var background: URL? {
        model.background
    }
    
    var emojis: [Emoji] {
        model.emojis
    }
    
    private static var lastSaveFileUrl: URL? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return documentsUrl.appending(path: "last.emojiart")
    }
    
    init() {
        guard let fileUrl = Self.lastSaveFileUrl else {
            return
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            self.model = try decoder.decode(EmojiArt.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
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

private extension EmojiArtDocument {
    func persist() {
        do {
            if let fileUrl = Self.lastSaveFileUrl {
                let encoder = JSONEncoder()
                let data = try encoder.encode(model)
                try data.write(to: fileUrl)
            } else {
                throw EmojiArtError.fileNotFound
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return .init(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
