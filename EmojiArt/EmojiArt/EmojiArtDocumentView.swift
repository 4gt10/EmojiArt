//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    private let paletteFontSize: CGFloat = 40
    
    @ObservedObject private(set) var viewModel: EmojiArtDocument
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            ScrollingEmojis(emojis)
                .font(.system(size: paletteFontSize))
                .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                AsyncImage(url: viewModel.background)
                    .position(Emoji.Position.zero.in(geometry))
                ForEach(viewModel.emojis) { emoji in
                    Text(emoji.emoji)
                        .font(.system(size: CGFloat(emoji.size)))
                        .position(emoji.position.in(geometry))
                }
            }
            .dropDestination(for: Sturldata.self) {
                drop($0, at: $1, in: geometry)
            }
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        guard let sturldata = sturldatas.first else {
            return false
        }
        switch sturldata {
        case .string(let emoji):
            viewModel.addEmoji(emoji, at: location, in: geometry, of: Int(paletteFontSize))
            return true
        case .url(let url):
            viewModel.setBackground(url)
            return true
        default:
            return false
        }
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
    EmojiArtDocumentView(viewModel: .init())
}
