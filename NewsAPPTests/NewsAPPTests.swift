//
//  NewsAPPTests.swift
//  NewsAPPTests
//
//  Created by Jason on 6/3/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import XCTest
@testable import NewsAPP

class MockSession: URLSessionProtocol {
    
    class DataTask: Cancellable {
        func cancel() { }
    }
    
    @discardableResult
    func getData(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable {
        let data = """
            {
               "status":"ok",
               "totalResults":1,
               "articles":[
                  {
                     "source":{
                        "id":"techcrunch",
                        "name":"TechCrunch"
                     },
                     "author":"Devin Coldewey",
                     "title":"Signal now has built-in face blurring for photos",
                     "description":"Apps like Signal are proving invaluable in these days of unrest, and anything we can do to simplify and secure the way we share sensitive information is welcome. To that end Signal has added the ability to blur faces in photos sent via the app, making it easy…",
                     "url":"https://techcrunch.com/2020/06/04/signal-now-has-built-in-face-blurring-for-photos/",
                     "urlToImage":"https://techcrunch.com/wp-content/uploads/2020/06/signal-blur-2.jpg?w=642",
                     "publishedAt":"2020-06-04T21:01:53Z",
                     "content":"Apps like Signal are proving invaluable in these days of unrest, and anything we can do to simplify and secure the way we share sensitive information is welcome. To that end Signal has added the abil… "
                  }
                  
               ]
            }
            """.data(using: .utf8)
        
        let dummyTask = DataTask()
        guard let finalData = data else {completion(.failure(WebAPI.ResponseError.unknown)); return dummyTask}
        completion(.success(finalData))
        return dummyTask
    }
    
    @discardableResult
    func getDecodedData<T>(_ urlString: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T : Decodable, T : Encodable {
        
        let dummy = self.getData(urlString) { (dataResult: Result<Data, Error>) in
            let result: Result<T, Error>
            switch dataResult {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    result = .success(response)
                } catch {
                    result = .failure(error)
                }
            case .failure(let error):
                result = .failure(error)
            }
            completion(result)
        }
        return dummy
    
    }
    
}


class NewsAPPTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let mock = MockSession()
        mock.getDecodedData("test.com") { (result: Result<RawNewsResponse, Error>) in
            switch result {
            case .success(let rawResp):
                XCTAssertEqual(rawResp.totalResults, 1)
                XCTAssertEqual(rawResp.articles[0].author, "Devin Coldewey")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }


}
