//
//  Extensions.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    public static var width: CGFloat {
        get {
            return self.main.bounds.size.width
        }
    }
    
    public static var height: CGFloat {
        get {
            return self.main.bounds.size.height
        }
    }
}
