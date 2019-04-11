//
//  SearchSuccessListProtocols.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation


protocol SuccessListViewInputProtocol: AnyObject {
    func updateView(viewModel: SearchSuccessListViewModel) -> Swift.Void
    func updateErrorInfo(errorDescription: String) -> Swift.Void
    func noMorePhotos() -> Swift.Void
}

protocol SuccessListViewOutputProtocol: AnyObject {
    var view: SuccessListViewInputProtocol? {get set}
    func pullUp() -> Swift.Void
}
