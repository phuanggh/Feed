//
//  FeedTests.swift
//  FeedTests
//
//  Created by Penny Huang on 2022/8/12.
//

import XCTest
@testable import Feed

class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "a-requested-url")!)
        // problems of using a shared instance ->
            // 1. mixing the responsibility of invoking a method in an object
            // 2. the reponsibility of locating this object. I know how to locate this object in memory, I know what instance I'm using, but I don't need to know them
        // if we inject our client, we have more control over our code
        
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

// there is nothing wrong to subclass, but we can use composition. composition over inheritance (OOP)
// to use composition, we can start by injection. injection upon the creation of RemoteFeedLoader
class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

class FeedTests: XCTestCase {
    
    func test_init_doseNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        
        _ = RemoteFeedLoader(client: client)
        // when feedLoader call load(), it requests something from the server
        // when feedLoader call load(), it invokes connection in its client
        // connection is made for a specific URL
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        // when it loads, we have to have request a URL through the client
        // how can RemoteFeedLoader invokes a mothod in the client? -> dependency injection, inject a client to RemoteFeedLoader
        // constructor injection
        // property injection
        // method injection
        
        XCTAssertNotNil(client.requestedURL)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
