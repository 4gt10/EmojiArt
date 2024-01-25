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
    
    mutating func remove(_ ch: String) {
        removeAll(where: { $0 == Character(ch) })
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

extension Character {
    var isEmoji: Bool {
        // Swift does not have a way to ask if a Character isEmoji
        // but it does let us check to see if our component scalars isEmoji
        // unfortunately unicode allows certain scalars (like 1)
        // to be modified by another scalar to become emoji (e.g. 1️⃣)
        // so the scalar "1" will report isEmoji = true
        // so we can't just check to see if the first scalar isEmoji
        // the quick and dirty here is to see if the scalar is at least the first true emoji we know of
        // (the start of the "miscellaneous items" section)
        // or check to see if this is a multiple scalar unicode sequence
        // (e.g. a 1 with a unicode modifier to force it to be presented as emoji 1️⃣)
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}
