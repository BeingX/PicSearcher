
//
//  HomeViewProtocols.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

protocol HomeViewInputProtocol: AnyObject {
    func updateView(viewModel: HomeViewModel) -> Swift.Void
    func updateErrorInfo(errorDescription: String) -> Swift.Void
}

protocol HomeViewOutputProtocol: AnyObject {
    var view: HomeViewInputProtocol? {get set}
    func queryWith(keyWord: String) -> Swift.Void
}
