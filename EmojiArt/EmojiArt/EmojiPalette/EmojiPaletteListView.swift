//
//  EmojiPaletteListView.swift
//  EmojiArt
//
//  Created by 4gt10 on 30.01.2024.
//

import SwiftUI

struct EmojiPaletteListView: View {
    @ObservedObject var store: EmojiPaletteStore
    
    @State private var isCursorPaletteShown = false
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(store.palettes) { palette in
                    NavigationLink(value: palette) {
                        paletteView(palette)
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        store.palettes.remove(atOffsets: indexSet)
                    }
                }
                .onMove { indices, newOffset in
                    store.palettes.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .navigationTitle("\(store.name) Palettes")
            .navigationDestination(for: EmojiPalette.self) { palette in
                if let index = store.palettes.firstIndex(where: { $0.id == palette.id }) {
                    EmojiPaletteEditorView(palette: $store.palettes[index])
                }
            }
            .navigationDestination(isPresented: $isCursorPaletteShown) {
                EmojiPaletteEditorView(palette: $store.palettes[store.cursorIndex])
            }
            .toolbar {
                Button { 
                    store.addEmptyPalette()
                    isCursorPaletteShown = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func paletteView(_ palette: EmojiPalette) -> some View {
        VStack(alignment: .leading) {
            Text(palette.name)
            Text(palette.emojis).lineLimit(1)
        }
    }
}

#Preview {
    @State var store = EmojiPaletteStore(named: "Preview")
    
    return EmojiPaletteListView(store: store)
}
