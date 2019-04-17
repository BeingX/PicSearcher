//
//  FlickrSearchApiService.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

fileprivate struct FlickrSearchApiConfig {
    fileprivate static let BaseUrlString = "https://api.flickr.com/services/rest/"
    fileprivate static var PerPagePicCount: Int {
        get {
            
            return UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
        }
    }
    fileprivate static let ApiKey: [UInt32] = [51, 57, 106, 109, 111, 64, 119, 118, 121, 128, 132, 135, 91, 91, 93, 94, 105, 108, 109, 105, 115, 115, 118, 170, 129, 176, 127, 129, 182, 136, 143, 146]
}

public class FlickrSearchApiService {
    private let diskCacher = FlickSearchResponseCacher<FlickrSearchApiResponseModel>()
    public func cachedKeyWith(tags: String, page: Int) -> String {
        return tags + "_" + String(page)
    }
    public func searchByTags(tags: String, page: Int?, completionHandler: @escaping (FlickrSearchApiResponseModel?, Error?) -> Void) {
        if !NetworkMonitor.shared.reachabilityManager!.isReachable {
            let pageIndex = page ?? 1
            if let cacheResonse = try? self.diskCacher.fetchCachedReponse(key: cachedKeyWith(tags: tags, page: pageIndex)) {
                completionHandler(cacheResonse, nil)
                return
            }
        }
 
        let parameter = self.requestParameters(tags: tags, page: page!, perPage: FlickrSearchApiConfig.PerPagePicCount)
        Alamofire.request(FlickrSearchApiConfig.BaseUrlString, parameters: parameter).responseJSON {[weak self] response in
            switch response.result {
            case .success:
                debugPrint(response)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(FlickrSearchApiResponseModel.self, from: jsonData)
                    
                    if responseModel.stat == "ok"{
                        let cacheKey = self?.cachedKeyWith(tags: tags, page: (responseModel.photos?.page)!)
                        _ = try self?.diskCacher.cache(key: cacheKey!, reponseModel: responseModel)
                        completionHandler(responseModel, nil)
                    } else {
                        completionHandler(nil, ApiError.serviceError)
                    }
                    
                } catch {
                    completionHandler(nil, error)
                }
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
            }
        }
        
    }
    
    private enum UrlParameterKey: String {
        case method
        case api_key
        case tags
        case format
        case nojsoncallback
        case per_page
        case page
    }
    
    enum ApiError: Error {
        case serviceError
        case statFail
    }
    
    private func requestParameters(tags: String, page: Int, perPage: Int) -> [String: String] {
        let parameter: [String: String] = [
            UrlParameterKey.method.rawValue: "flickr.photos.search",
            UrlParameterKey.api_key.rawValue: StringMask(maskBte: FlickrSearchApiConfig.ApiKey).value()!,
            UrlParameterKey.tags.rawValue: tags,
            UrlParameterKey.per_page.rawValue: String(perPage),
            UrlParameterKey.page.rawValue: String(page),
            UrlParameterKey.format.rawValue: "json",
            UrlParameterKey.nojsoncallback.rawValue: "1",
            ]
        return parameter
    }
}
