//
//  Extensions.swift
//  EmojiArt
//
//  Created by 4gt10 on 11.01.2024.
//

import Foundation

typealias CGOffset = CGSize

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

extension CGOffset {
    static func +(lhs: CGOffset, rhs: CGOffset) -> CGOffset {
        .init(width: (lhs.width + rhs.width), height: (lhs.height + rhs.height))
    }
    
    static func +=(lhs: inout CGOffset, rhs: CGOffset) {
        lhs = lhs + rhs
    }
}
