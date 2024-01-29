//
//  EmojiPaletteStore.swift
//  EmojiArt
//
//  Created by 4gt10 on 12.01.2024.
//

import SwiftUI

final class EmojiPaletteStore: ObservableObject {
    let name: String

    var palettes: [EmojiPalette] {
        get {
            defaults.getPalettes(forKey: userDefaultsKey)
        }
        set {
            defaults.setPalettes(newValue, forKey: userDefaultsKey)
            objectWillChange.send()
        }
    }
    @Published private(set) var cursorIndex = 0
    
    private let defaults = UserDefaults.standard
    private var userDefaultsKey: String {
        "Emoji Palette: \(name)"
    }
    
    init(named name: String) {
        self.name = name
        if palettes.isEmpty {
            palettes = EmojiPalette.builtins
        }
    }
    
    // MARK: - Intent(s)
    
    func addEmptyPalette() {
        palettes.append(EmojiPalette(name: "", emojis: ""))
        if let lastIndex = palettes.indices.last {
            cursorIndex = lastIndex
        }
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

extension UserDefaults {
    func getPalettes(forKey key: String) -> [EmojiPalette] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([EmojiPalette].self, from: data)) ?? []
    }
    
    func setPalettes(_ palettes: [EmojiPalette], forKey key: String) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(palettes)
        UserDefaults.standard.setValue(data, forKey: key)
    }
}
