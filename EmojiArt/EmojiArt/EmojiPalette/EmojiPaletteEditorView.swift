//
//  EmojiPaletteEditorView.swift
//  EmojiArt
//
//  Created by 4gt10 on 25.01.2024.
//

import SwiftUI

struct EmojiPaletteEditorView: View {
    private enum Constant {
        static let emojiSize = CGFloat(40.0)
        static let emojiFont = Font.system(size: emojiSize)
    }
    
    enum FocusedTextField {
        case name
        case emojis
    }
    
    @Binding var palette: EmojiPalette
    
    @State private var emojisToAdd = ""
    
    @FocusState private var focusedTextField: FocusedTextField?
    
    var body: some View {
        Form {
            TextField("Palette Name", text: $palette.name)
                .focused($focusedTextField, equals: .name)
            TextField("Add Emojis Here", text: $emojisToAdd)
                .font(Constant.emojiFont)
                .focused($focusedTextField, equals: .emojis)
                .onChange(of: emojisToAdd) {
                    palette.emojis = (emojisToAdd + palette.emojis)
                        .filter { $0.isEmoji }
                        .uniqued
                }
            if !palette.emojis.isEmpty {
                emojiRemover
            }
        }
        .onAppear {
            focusedTextField = palette.name.isEmpty ? .name : .emojis
        }
    }
    
    private var emojiRemover: some View {
        VStack(alignment: .trailing) {
            Text("Tap to Remove Emojis").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constant.emojiSize))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                emojisToAdd.remove(emoji)
                                palette.emojis.remove(emoji)
                            }
                        }
                }
            }
        }
        .font(Constant.emojiFont)
    }
}

#Preview {
    @State var store = EmojiPaletteStore(named: "Preview")
    
    return EmojiPaletteEditorView(palette: $store.palettes.first!)
}
