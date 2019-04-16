//
//  FlickrSearchApiResponseModel.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

public struct FlickrSearchApiResponseModel: Codable {
    let stat: String
    let code: Int?
    let message: String?
    struct Photos: Codable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: String
        struct PhotoModel: Codable {
            enum CodingKeys: String, CodingKey {
                case photoId = "id"
                case owner = "owner"
                case secret = "secret"
                case server = "server"
                case farm = "farm"
                case title = "title"
                case ispublic = "ispublic"
                case isfriend = "isfriend"
                case isfamily = "isfamily"
            }
            
            let photoId: String
            let owner: String
            let secret: String
            let server: String
            let farm: Int
            let title: String
            let ispublic: Int
            let isfriend: Int
            let isfamily: Int
            var imageThumbUrl: String? {
                get {
                    return "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_t.jpg"
                }
            }
            var imageUrl: String? {
                get {
                    return "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret).jpg"
                }
            }
        }
        let photo: [PhotoModel]
    }
    let photos: Photos?
}
