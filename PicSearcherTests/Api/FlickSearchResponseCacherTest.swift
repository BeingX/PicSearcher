//
//  FlickSearchResponseCacherTest.swift
//  PicSearcherTests
//
//  Created by 尹啟星 on 2019/4/16.
//  Copyright © 2019 xingxing. All rights reserved.
//

import XCTest
@testable import PicSearcher

struct MockResponseModel: Codable {
    let id: String
}
class FlickSearchResponseCacherTest: XCTestCase {
    var sut = FlickSearchResponseCacher<MockResponseModel>()
    
    override func setUp() {
        super.setUp()
        clearAll()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
//        clearAll()
    }
    func clearAll() {
        do {
            try sut.clearAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    func cacheWithKey(key: String, model: MockResponseModel) -> String? {
        var path: String?
        do {
            path = try sut.cache(key: key, reponseModel: model)
        } catch {
            XCTFail(error.localizedDescription)
        }
        return path
    }
    func fetchModel(key: String) -> MockResponseModel? {
        var model: MockResponseModel?
        do {
            model = try sut.fetchCachedReponse(key: key)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        return model
    }
    func testCacheAndFetchAndDelete() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let cacheKey = "testCacheAndFetchAndDelete"
        let modelId = "testCacheAndFetchAndDelete"
        let model = MockResponseModel(id: modelId)
        let path = cacheWithKey(key: cacheKey, model: model)
        XCTAssertNotNil(path)
        XCTAssertTrue(FileManager.default.fileExists(atPath: path!))
        
        debugPrint(sut.storePath)
        let fetchedModle = fetchModel(key: cacheKey)
        XCTAssertNotNil(fetchedModle)
        XCTAssertEqual(fetchedModle?.id, modelId)
        
        do {
            try sut.deleteCachedReponse(key: cacheKey)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        XCTAssertFalse(FileManager.default.fileExists(atPath: path!))
    }
}
