//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    private let paletteFontSize: CGFloat = 40
    
    @ObservedObject private(set) var viewModel: EmojiArtDocument
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            EmojiPaletteView()
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
                    .scaleEffect(zoom * zoomGestureState)
                    .offset(pan + panGestureState)
                    .gesture(panGesture.simultaneously(with: zoomGesture))
                    .onTapGesture {
                        selectedEmojisIds.removeAll()
                    }
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
            let isSelected = selectedEmojisIds.contains(emoji.id)
            Text(emoji.emoji)
                .font(.system(size: CGFloat(emoji.size)))
                .border(selectionBorder(for: emoji), width: 2)
                .scaleEffect(isSelected ? selectedEmojisZoomGestureState : 1)
                .offset(isSelected ? selectedEmojisPanGestureState : .zero)
                .position(emoji.position.in(geometry))
                .gesture(selectedEmojisPanGesture, including: isSelected ? .gesture : .subviews)
                .onTapGesture {
                    if let index = selectedEmojisIds.firstIndex(of: emoji.id) {
                        selectedEmojisIds.remove(at: index)
                    } else {
                        selectedEmojisIds.append(emoji.id)
                    }
                }
        }
    }
    
    private func selectionBorder(for emoji: Emoji) -> some ShapeStyle {
        selectedEmojisIds.contains(emoji.id) ? AnyShapeStyle(SelectionShapeStyle()) : AnyShapeStyle(.clear)
    }
    
    // MARK: - Document gestures
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @GestureState private var zoomGestureState: CGFloat = 1
    @GestureState private var panGestureState: CGOffset = .zero
    
    private var zoomGesture: some Gesture {
        selectedEmojisIds.isEmpty
            ? MagnificationGesture()
                .updating($zoomGestureState) { value, state, _ in state = value }
                .onEnded { zoom *= $0 }
            : MagnificationGesture()
                .updating($selectedEmojisZoomGestureState) { value, state, _ in state = value }
                .onEnded { applyZoomToSelectedEmojis($0) }
        
    }
    private var panGesture: some Gesture {
        DragGesture()
            .updating($panGestureState) { value, state, _ in state = value.translation }
            .onEnded { pan += $0.translation }
    }
    
    // MARK: - Selection gestures
    
    @State private var selectedEmojisIds = [Emoji.ID]()
    
    @GestureState private var selectedEmojisZoomGestureState: CGFloat = 1
    @GestureState private var selectedEmojisPanGestureState: CGOffset = .zero
    
    private var selectedEmojisPanGesture: some Gesture {
        DragGesture()
            .updating($selectedEmojisPanGestureState) { value, state, _ in state = value.translation }
            .onEnded { applyPanToSelectedEmojis($0.translation) }
    }
    
    private func applyZoomToSelectedEmojis(_ zoom: CGFloat) {
        selectedEmojisIds.forEach { emojiId in
            if let initial = viewModel.emojis.first(where: { $0.id == emojiId })?.size {
                viewModel.updateEmoji(id: emojiId, size: Int(CGFloat(initial) * zoom))
            }
        }
    }
    
    private func applyPanToSelectedEmojis(_ pan: CGOffset) {
        selectedEmojisIds.forEach { emojiId in
            if let initial = viewModel.emojis.first(where: { $0.id == emojiId })?.position {
                viewModel.updateEmoji(
                    id: emojiId,
                    position: .init(x: initial.x + Int(pan.width), y: initial.y - Int(pan.height))
                )
            }
        }
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

#Preview {
    EmojiArtDocumentView(viewModel: .init())
        .environmentObject(EmojiPaletteStore(named: "Preview"))
}
