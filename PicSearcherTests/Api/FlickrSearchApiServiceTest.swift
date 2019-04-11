//
//  FlickrSearchApiServiceTest.swift
//  PicSearcherTests
//
//  Created by 尹啟星 on 2019/4/11.
//  Copyright © 2019 xingxing. All rights reserved.
//

import XCTest
@testable import PicSearcher

class FlickrSearchApiServiceTest: XCTestCase {
    var sut: FlickrSearchApiService!
    override func setUp() {
        sut = FlickrSearchApiService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.diskCacher.clearCachedReponse(key: sut.cachedKeyWith(tags: "beauty", page: 1))
        sut.diskCacher.clearCachedReponse(key: sut.cachedKeyWith(tags: "xx xx", page: 1))
    }
    
    func testSearchByTags_general() {
        let promise = self.expectation(description: "FlickrSearchApiService")
        sut.searchByTags(tags: "beauty", page: 1) { (responseModel, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(responseModel)
            promise.fulfill()
        }
        self.waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testSearchByTags_mid_whitespace() {
        let promise = self.expectation(description: "FlickrSearchApiService")
        sut.searchByTags(tags: "xx xx", page: 1) { (responseModel, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(responseModel)
            promise.fulfill()
        }
        self.waitForExpectations(timeout: 20, handler: nil)
    }

}
