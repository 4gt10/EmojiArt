//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject private var defaultDocument = EmojiArtDocument()
    @StateObject private var mainPalette = EmojiPaletteStore(named: "Main")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(viewModel: defaultDocument)
                .environmentObject(mainPalette)
        }
    }
}
