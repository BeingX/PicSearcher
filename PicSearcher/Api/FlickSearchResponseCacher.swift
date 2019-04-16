//
//  FlickSearchResponseCacher.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/10.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation

public class FlickSearchResponseCacher<T: Codable> {
    public var storePath: String {
        get {
            let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let dir = documentPaths.first! + "/FlickSearchResponse"
            return dir
        }
    }
    public func cache(key: String, reponseModel: T) throws -> String? {
        assert(!key.isEmpty, "key can not be empty")
        guard !key.isEmpty else {
            return nil
        }
        self.creatCacheDirIfNo()
        let path = self.cacheFileFullPath(key: key)
        let url = URL(fileURLWithPath: path)
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(reponseModel)
        try jsonData.write(to: url)
        return path
    }
    
    public func fetchCachedReponse(key: String) throws -> T? {
        var responseModel: T?
        let filePath = self.cacheFileFullPath(key: key)
        let jsonDecoder = JSONDecoder()
        if FileManager.default.fileExists(atPath: filePath) {
            if let jsonData = NSData(contentsOfFile: filePath) {
                responseModel = try jsonDecoder.decode(T.self, from: jsonData as Data)
            }
        }
        return responseModel
    }
    
    public func clearAll() throws {
        if FileManager.default.fileExists(atPath: storePath) {
            try FileManager.default.removeItem(atPath: storePath)
        }
    }
    
    public func deleteCachedReponse(key: String) throws {
        let filePath = self.cacheFileFullPath(key: key)
        if FileManager.default.fileExists(atPath: filePath) {
           try FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    private func creatCacheDirIfNo() {
        if !FileManager.default.fileExists(atPath: storePath) {
            do {
                try FileManager.default.createDirectory(atPath: storePath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    private func cacheFileFullPath(key: String) -> String {
        let fileName = "/" + key
        return storePath + fileName.lowercased()
    }
}
