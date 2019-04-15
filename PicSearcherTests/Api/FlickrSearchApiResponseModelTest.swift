//
//  FlickrSearchApiResponseModelTest.swift
//  PicSearcherTests
//
//  Created by 尹啟星 on 2019/4/14.
//  Copyright © 2019 xingxing. All rights reserved.
//

import XCTest
@testable import PicSearcher

class FlickrSearchApiResponseModelTest: XCTestCase {
    var exampleJson: [String: Any]!
    var exampleFailJson: [String: Any]!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        exampleJson = [ "photos":
            [ "page": 1, "pages": 25, "perpage": 20, "total": "498",
              "photo": [
                [ "id": "43802561894", "owner": "24406544@N00", "secret": "2c6b811898", "server": "1885", "farm": 2, "title": "Vondelpark - Amsterdam (Netherlands)", "ispublic": 1, "isfriend": 0, "isfamily": 0 ],
                [ "id": "30630642468", "owner": "24406544@N00", "secret": "a7bbbff907", "server": "1881", "farm": 2, "title": "Vondelpark - Amsterdam (Netherlands)", "ispublic": 1, "isfriend": 0, "isfamily": 0 ],
                [ "id": "29500527238", "owner": "24406544@N00", "secret": "5d963b7e3e", "server": "1808", "farm": 2, "title": "Museumplein - Amsterdam (Netherlands)", "ispublic": 1, "isfriend": 0, "isfamily": 0 ],
                [ "id": "37630671380", "owner": "24406544@N00", "secret": "20a837909a", "server": "4473", "farm": 5, "title": "Vondelpark - Amsterdam (Netherlands)", "ispublic": 1, "isfriend": 0, "isfamily": 0 ],
                ] ],
                        "stat": "ok" ]
        
        exampleFailJson = [ "stat": "fail", "code": 3, "message": "Parameterless searches have been disabled. Please use flickr.photos.getRecent instead." ]
        
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessResponseCodable() {
        
        var response: FlickrSearchApiResponseModel?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: exampleJson as Any, options: [])
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(FlickrSearchApiResponseModel.self, from: jsonData)
            response = responseModel
            XCTAssertNotNil(responseModel)
            XCTAssertEqual(responseModel.photos?.page, 1)
            XCTAssertEqual(responseModel.photos?.pages, 25)
            XCTAssertEqual(responseModel.photos?.perpage, 20)
            XCTAssertEqual(responseModel.photos?.total, "498")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(response)
            if let jsonObject: [String: Any] = try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]) {
                XCTAssertTrue(NSDictionary(dictionary: jsonObject).isEqual(to: exampleJson))
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailResponseCodable() {
        
        var response: FlickrSearchApiResponseModel?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: exampleFailJson as Any, options: [])
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(FlickrSearchApiResponseModel.self, from: jsonData)
            response = responseModel
            XCTAssertNotNil(responseModel)
            XCTAssertEqual(responseModel.stat, "fail")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(response)
            if let jsonObject: [String: Any] = try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]) {
                XCTAssertTrue(NSDictionary(dictionary: jsonObject).isEqual(to: exampleFailJson))
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
