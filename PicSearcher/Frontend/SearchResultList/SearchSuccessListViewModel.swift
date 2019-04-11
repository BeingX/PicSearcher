//
//  SearchSuccessListViewModel.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

struct SearchSuccessListViewModel {
    var photos = [FlickrSearchApiResponseModel.Photos.PhotoModel]()
    var progressString = ""
    var searchKey: String?
}
