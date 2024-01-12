//
//  EmojiPaletteStore.swift
//  EmojiArt
//
//  Created by 4gt10 on 12.01.2024.
//

import SwiftUI

final class EmojiPaletteStore: ObservableObject {
    let name: String

    @Published private(set) var palettes: [EmojiPalette]
    @Published private(set) var cursor = 0
    
    private static var allPalettes: [EmojiPalette] { EmojiPalette.builtins }
    
    init(named name: String) {
        self.name = name
        self.palettes = Array(Self.allPalettes.prefix(upTo: Self.allPalettes.count / 2)) // half of what we got
        if palettes.isEmpty {
            palettes.append(.init(name: "Warning", emojis: "⚠️"))
        }
    }
    
    // MARK: - Intent(s)
    
    func addPalette() {
        let nextCursor = palettes.count
        guard nextCursor < Self.allPalettes.count else {
            return
        }
        palettes.append(Self.allPalettes[nextCursor])
        cursor = nextCursor
    }
    
    func removePalette() {
        guard palettes.count > 1 else {
            return
        }
        palettes.remove(at: cursor)
        goPreviousPalette()
    }
    
    func goNextPalette() {
        let nextCursor = cursor + 1
        guard nextCursor < palettes.count else {
            cursor = 0
            return
        }
        cursor = nextCursor
    }
    
    func goPreviousPalette() {
        guard cursor > 0 else {
            return
        }
        cursor -= 1
    }
}
