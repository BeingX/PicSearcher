//
//  Extensions.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation
import UIKit

public extension FileManager {
    public enum SizeUnitType: String {
        case MB
        case Byte
        case KB
    }
    public func cachesDirectoryFileSize(unit: SizeUnitType = .MB) -> String {
        var totalSize = "0.00"
        if let path = cachesDirectoryPath() {
            totalSize = fileSize(atPath: path, unit: unit)
        }
        return totalSize
    }

    public func clearCachesDirectory() {
        if let path = cachesDirectoryPath() {
            do {
                try FileManager.default.removeItem(atPath: path)
                debugPrint("clear path:" + path )
            } catch {
                debugPrint(error)
            }
        }
    }
    func cachesDirectoryPath() -> String? {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let dir = documentPaths.first
        return dir
    }
    public func fileSize(atPath path: String, unit: SizeUnitType = .MB) -> String {
        var totalSize: Double = 0.0
        if fileExists(atPath: path) {
            let fileUrl = URL(fileURLWithPath: path)
            if let size = try? FileManager.default.allocatedSizeOfDirectory(at: fileUrl) {
                totalSize = Double(size)
            }
            switch unit {
            case .MB:
                totalSize = totalSize/1024/1024
            case .Byte:
                break
            case .KB:
                totalSize = totalSize/1024
            }
        }
        let doubleStr = String(format: "%.2f %@", totalSize, unit.rawValue)
        return doubleStr
    }
    
}
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

public extension FileManager {
    
    /// Calculate the allocated size of a directory and all its contents on the volume.
    ///
    /// As there's no simple way to get this information from the file system the method
    /// has to crawl the entire hierarchy, accumulating the overall sum on the way.
    /// The resulting value is roughly equivalent with the amount of bytes
    /// that would become available on the volume if the directory would be deleted.
    ///
    /// - note: There are a couple of oddities that are not taken into account (like symbolic links, meta data of
    /// directories, hard links, ...).
    
    public func allocatedSizeOfDirectory(at directoryURL: URL) throws -> UInt64 {
        
        // The error handler simply stores the error and stops traversal
        var enumeratorError: Error?
        func errorHandler(_: URL, error: Error) -> Bool {
            enumeratorError = error
            return false
        }
        
        // We have to enumerate all directory contents, including subdirectories.
        let enumerator = self.enumerator(at: directoryURL,
                                         includingPropertiesForKeys: Array(allocatedSizeResourceKeys),
                                         options: [],
                                         errorHandler: errorHandler)!
        
        // We'll sum up content size here:
        var accumulatedSize: UInt64 = 0
        
        // Perform the traversal.
        for item in enumerator {
            
            // Bail out on errors from the errorHandler.
//            if enumeratorError != nil { break }
            // Add up individual file sizes.
            if let contentItemURL = item as? URL {
                accumulatedSize += try contentItemURL.regularFileAllocatedSize()
            }
        }
        
        // Rethrow errors from errorHandler.
//        if let error = enumeratorError { throw error }
        
        return accumulatedSize
    }
}

fileprivate let allocatedSizeResourceKeys: Set<URLResourceKey> = [
    .isRegularFileKey,
    .fileAllocatedSizeKey,
    .totalFileAllocatedSizeKey,
]

fileprivate extension URL {
    
    func regularFileAllocatedSize() throws -> UInt64 {
        let resourceValues = try self.resourceValues(forKeys: allocatedSizeResourceKeys)
        
        // We only look at regular files.
        guard resourceValues.isRegularFile ?? false else {
            return 0
        }
        
        // To get the file's size we first try the most comprehensive value in terms of what
        // the file may use on disk. This includes metadata, compression (on file system
        // level) and block size.
        
        // In case totalFileAllocatedSize is unavailable we use the fallback value (excluding
        // meta data and compression) This value should always be available.
        
        return UInt64(resourceValues.totalFileAllocatedSize ?? resourceValues.fileAllocatedSize ?? 0)
    }
}
