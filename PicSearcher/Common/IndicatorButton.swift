//
//  IndicatorButton.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit
import SnapKit

class IndicatorButton: UIButton {
    var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor.white
        return indicator
    }()
    func showLoadingFace() -> Swift.Void {
        DispatchQueue.main.async {
            if self.indicator.superview == nil {
                self.addSubview(self.indicator)
                self.indicator.snp.makeConstraints { (maker) in
                    maker.edges.equalToSuperview()
                }
            }
            self.indicator.isHidden = false
            self.bringSubviewToFront(self.indicator)
            self.indicator.startAnimating()
            self.isEnabled = false
        }
        
    }
    func hideLoadingFace() -> Swift.Void {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.isEnabled = true
        }
        
    }
    
}
