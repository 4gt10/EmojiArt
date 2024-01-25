//
//  EmojiPaletteStore.swift
//  EmojiArt
//
//  Created by 4gt10 on 12.01.2024.
//

import SwiftUI

final class EmojiPaletteStore: ObservableObject {
    let name: String

    @Published var palettes: [EmojiPalette]
    @Published private(set) var cursorIndex = 0
    
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
        cursorIndex = nextCursor
    }
    
    func removePalette() {
        guard palettes.count > 1 else {
            return
        }
        palettes.remove(at: cursorIndex)
        goToPreviousPalette()
    }
    
    func goToNextPalette() {
        let nextCursor = cursorIndex + 1
        guard nextCursor < palettes.count else {
            cursorIndex = 0
            return
        }
        cursorIndex = nextCursor
    }
    
    func goToPreviousPalette() {
        guard cursorIndex > 0 else {
            return
        }
        cursorIndex -= 1
    }
    
    func goToPalette(atIndex index: Int) {
        guard palettes.indices.contains(index) && index != cursorIndex else {
            return
        }
        cursorIndex = index
    }
}
