//
//  StringMask.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

/// this wrapper only store byte date. Hackers don't know the true value unless they know the encryption algorithm
class StringMask {
    private var mask = [UInt32]()
    init(origial: String) {
        self.putOnmask(origial: origial)
    }
    
    init(maskBte: [UInt32]) {
        self.mask = maskBte
    }
    
    deinit {
        self.mask.removeAll()
    }
    
    func value() -> String? {
        guard !mask.isEmpty else {
            return nil
        }
        return self.showFace(chars: mask)
    }
    
    // the algorithm here can be more complicated and harder to crack
    private func putOnmask(origial: String) {
        mask = origial.unicodeScalars.enumerated().map { index, char in
            let join = char.value + UInt32(index*3)
            return join
        }
    }
    
    private func showFace(chars: [UInt32]) -> String {
        return chars.enumerated().map { (index, char) -> String in
            let s = UnicodeScalar(char - UInt32(index*3))!
            return "\(Character(s))"
            }.joined()
    }
}
