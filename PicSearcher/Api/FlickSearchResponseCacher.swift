//
//  FlickSearchResponseCacher.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

class FlickSearchResponseCacher<T: Codable> {
    func cache(key: String, reponseModel: T) {
        assert(!key.isEmpty, "key can not be empty")
        guard !key.isEmpty else {
            return
        }
        self.creatCacheDirIfNo()
        let url = URL(fileURLWithPath: self.cacheFileFullPath(key: key))
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(reponseModel)
            try jsonData.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func fetchCachedReponse(key: String) -> T? {
        var responseModel: T?
        let filePath = self.cacheFileFullPath(key: key)
        let jsonDecoder = JSONDecoder()
        if FileManager.default.fileExists(atPath: filePath) {
            if let url = URL(string: filePath), let jsonData = try? Data(contentsOf: url) {
                responseModel = try? jsonDecoder.decode(T.self, from: jsonData)
            }
        }
        return responseModel
    }
    
    func clearAll() {
        if FileManager.default.fileExists(atPath: self.cacheDir()) {
            do {
                try FileManager.default.removeItem(atPath: self.cacheDir())
            } catch {
                print(error)
            }
        }
    }
    
    func clearCachedReponse(key: String) {
        let filePath = self.cacheFileFullPath(key: key)
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print(error)
            }
        }
    }
    
    func creatCacheDirIfNo() {
        if !FileManager.default.fileExists(atPath: self.cacheDir()) {
            do {
                try FileManager.default.createDirectory(atPath: self.cacheDir(), withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    func cacheFileFullPath(key: String) -> String {
        let fileName = "/" + key
        return self.cacheDir() + fileName.lowercased()
    }
    
    func cacheDir() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return documentPaths.first! + "/cache"
    }
}
