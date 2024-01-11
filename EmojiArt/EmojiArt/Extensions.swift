//
//  Extensions.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import Foundation

extension String {
    var uniqued: String {
        reduce(into: "") { partialResult, character in
            if !partialResult.contains(character) {
                partialResult.append(character)
            }
        }
    }
}

extension CGRect {
    var center: CGPoint {
        .init(x: midX, y: midY)
    }
}
