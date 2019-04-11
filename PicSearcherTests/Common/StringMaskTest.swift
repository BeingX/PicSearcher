//
//  StringMaskTest.swift
//  PicSearcherTests
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import XCTest
@testable import PicSearcher

class StringMaskTest: XCTestCase {
    
    func testMaskString() {
        let string1 = "   "
        let stringMasker1 = StringMask(origial: string1)
        XCTAssertEqual(stringMasker1.value()!, string1)
        
        let string2 = "VanMoof"
        let stringMasker2 = StringMask(origial: string2)
        XCTAssertEqual(stringMasker2.value()!, string2)
        
        let string3 = "!@#$%^&*())_+\"<>?ZXCDDSWWWSSD@mnb"
        let stringMasker3 = StringMask(origial: string3)
        XCTAssertEqual(stringMasker3.value()!, string3)
        
        let string4 = "🐶👩‍👩‍👧‍👦👧👦"
        let stringMasker4 = StringMask(origial: string4)
        XCTAssertEqual(stringMasker4.value()!, string4)
    }
    
    func testByteToString() {
        // VanMoof
        let byte1: [UInt32] = [86, 100, 116, 86, 123, 126, 120]
        let stringMasker1 = StringMask(maskBte: byte1)
        
        // Amsterdam
        let byte2: [UInt32] = [65, 112, 121, 125, 113, 129, 118, 118, 133]
        let stringMasker2 = StringMask(maskBte: byte2)
        
        // !@#$%^&*())_+\"<>?ZXCDDSWWWSSD@mnb
        let byte3: [UInt32] = [33, 67, 41, 45, 49, 109, 56, 63, 64, 68, 71, 128, 79, 73, 102, 107, 111, 141, 142, 124, 128, 131, 149, 156, 159, 162, 161, 164, 152, 151, 199, 203, 194]
        let stringMasker3 = StringMask(maskBte: byte3)
        
        // 🐶👩‍👩‍👧‍👦👧👦
        let byte4: [UInt32] = [128054, 128108, 8211, 128114, 8217, 128118, 8223, 128123, 128127, 128129]
        let stringMasker4 = StringMask(maskBte: byte4)
        
        XCTAssertEqual(stringMasker1.value(), "VanMoof")
        XCTAssertEqual(stringMasker2.value(), "Amsterdam")
        XCTAssertEqual(stringMasker3.value(), "!@#$%^&*())_+\"<>?ZXCDDSWWWSSD@mnb")
        XCTAssertEqual(stringMasker4.value(), "🐶👩‍👩‍👧‍👦👧👦")
    }
}
