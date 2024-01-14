//
//  EmojiPaletteView.swift
//  EmojiArt
//
//  Created by 4gt10 on 12.01.2024.
//

import SwiftUI

struct EmojiPaletteView: View {
    @EnvironmentObject var viewModel: EmojiPaletteStore
    
    var body: some View {
        HStack {
            chooser
                .contextMenu {
                    AnimatedActionButton("Add", systemImage: "plus") {
                        viewModel.addPalette()
                    }
                    AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive) {
                        viewModel.removePalette()
                    }
                }
                .animation(nil, value: viewModel.cursor)
            palette(at: viewModel.cursor)
                .id(viewModel.palettes[viewModel.cursor].id)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
        }
        .clipped()
    }
    
    private var chooser: some View {
        AnimatedActionButton(viewModel.palettes[viewModel.cursor].name, systemImage: "paintpalette") {
            viewModel.goNextPalette()
        }
        .padding(.horizontal)
        .foregroundStyle(.foreground)
        .background(.background, in: RoundedRectangle(cornerRadius: 10))
    }
    
    private func palette(at index: Int) -> some View {
        ScrollingEmojis(viewModel.palettes[index].emojis)
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiPaletteView()
        .environmentObject(EmojiPaletteStore(named: "Preview"))
}
