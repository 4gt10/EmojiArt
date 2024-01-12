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
    
    // MARK: - Views
    
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
                documentContents(in: geometry)
                    .scaleEffect(zoom * zoomState)
                    .offset(pan + panState)
                    .gesture(panGesture.simultaneously(with: zoomGesture))
            }
            .dropDestination(for: Sturldata.self) {
                drop($0, at: $1, in: geometry)
            }
        }
    }
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: viewModel.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(viewModel.emojis) { emoji in
            Text(emoji.emoji)
                .font(.system(size: CGFloat(emoji.size)))
                .position(emoji.position.in(geometry))
        }
    }
    
    // MARK: - Gestures
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @GestureState private var zoomState: CGFloat = 1
    @GestureState private var panState: CGOffset = .zero
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomState) { value, zoomState, _ in zoomState = value }
            .onEnded { zoom *= $0 }
    }
    private var panGesture: some Gesture {
        DragGesture()
            .updating($panState) { value, panState, _ in panState = value.translation }
            .onEnded { pan += $0.translation }
    }
    
    // MARK: - Drag & drop
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        guard let sturldata = sturldatas.first else {
            return false
        }
        switch sturldata {
        case .string(let emoji):
            viewModel.addEmoji(
                emoji,
                at: emojiPosition(at: location, in: geometry),
                of: Int(paletteFontSize / zoom)
            )
            return true
        case .url(let url):
            viewModel.setBackground(url)
            return true
        default:
            return false
        }
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry
            .frame(in: .local)
            .offsetBy(dx: pan.width, dy: pan.height)
            .center
        return .init(
            x: Int((location.x - center.x) / zoom),
            y: Int((center.y - location.y) / zoom)
        )
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
