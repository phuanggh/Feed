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
    let url: URL
    
    // the RemoteFeedLoader does not need to locate or instantiate the HTTPClient instance, so we make our code more modular by injecting a HTTPClient as a dependency
    // When you use singlnton for convenience of finding an instance of a type, it is often considered n anti-pattern
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
        // problems of using a shared instance ->
            // 1. mixing the responsibility of invoking a method in an object
            // 2. the reponsibility of locating this object. I know how to locate this object in memory, I know what instance I'm using, but I don't need to know them
        // if we inject our client, we have more control over our code
        // the HTTPClient has no reason to be a sinlgeton. To justy the creation of a singleton, you need to have a good reason, for example, you only want to have 1 HTTPClient per application.
        
        // is it the responsibility of this FeedLoader to know which URL it is getting data from, or it is given this URL?
        // -> we don't know, and we don't care about it. let's why it can be injected
    }
}

protocol HTTPClient {
    func get(from url: URL)
}
 
class FeedTests: XCTestCase {
    
    func test_init_doseNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        
        _ = makeSUT()
        // when feedLoader call load(), it requests something from the server
        // when feedLoader call load(), it invokes connection in its client
        // connection is made for a specific URL
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "test.injected.url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        // when it loads, we have to have request a URL through the client
        // how can RemoteFeedLoader invokes a mothod in the client? -> dependency injection, inject a client to RemoteFeedLoader
            // constructor injection
            // property injection
            // method injection
        
        // URL is a detail of the implementation of FeedLoader, so it should not be in public interface (should not be defined in paramaters)
        // FeedLoader defines load(), but it can load from a cache, it can load from multiple locations
        // it is client's responsibility to know about URLs
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "test.injected.url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }

    // there is nothing wrong to subclass, but we can use composition. composition over inheritance (OOP)
    // to use composition, we can start by injection. injection upon the creation of RemoteFeedLoader
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
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
