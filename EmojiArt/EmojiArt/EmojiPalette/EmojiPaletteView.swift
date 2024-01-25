//
//  EmojiPaletteView.swift
//  EmojiArt
//
//  Created by 4gt10 on 12.01.2024.
//

import SwiftUI

struct EmojiPaletteView: View {
    @EnvironmentObject var viewModel: EmojiPaletteStore
    
    @State private var isPaletteEditorShown = false
    
    var body: some View {
        HStack {
            chooser
                .contextMenu {
                    gotoMenu
                    AnimatedActionButton("Add", systemImage: "plus") {
                        viewModel.addPalette()
                    }
                    AnimatedActionButton("Edit", systemImage: "pencil") {
                        isPaletteEditorShown = true
                    }
                    AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive) {
                        viewModel.removePalette()
                    }
                }
                .animation(nil, value: viewModel.cursorIndex)
            palette(at: viewModel.cursorIndex)
                .id(viewModel.palettes[viewModel.cursorIndex].id)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
        }
        .clipped()
        .sheet(isPresented: $isPaletteEditorShown) {
            EmojiPaletteEditorView(palette: $viewModel.palettes[viewModel.cursorIndex])
                .font(nil)
        }
    }
    
    private var gotoMenu: some View {
        Menu {
            ForEach(viewModel.palettes) { palette in
                AnimatedActionButton(palette.name) {
                    guard let index = viewModel.palettes.firstIndex(where: { $0.id == palette.id }) else {
                        return
                    }
                    viewModel.goToPalette(atIndex: index)
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }

    }
    
    private var chooser: some View {
        AnimatedActionButton(viewModel.palettes[viewModel.cursorIndex].name, systemImage: "paintpalette") {
            viewModel.goToNextPalette()
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
