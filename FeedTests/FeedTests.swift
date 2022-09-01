//
//  FeedTests.swift
//  FeedTests
//
//  Created by Penny Huang on 2022/8/12.
//

import XCTest
import Feed
// @testable vs import

class FeedTests: XCTestCase {
    
    func test_init_doseNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        
        _ = makeSUT()
        // when feedLoader call load(), it requests something from the server
        // when feedLoader call load(), it invokes connection in its client
        // connection is made for a specific URL
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
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
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURL() {
        let url = URL(string: "test.injected.url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        // Stubbing
//        client.error = NSError(domain: "test", code: 0, userInfo: nil)
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load {
            capturedError.append($0)
        }
        let clientError = NSError(domain: "test", code: 0, userInfo: nil)
        
        // Capturing calue
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
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
        var requestedURLs: [URL] = []
//        var error: Error?
        var completions = [(Error) -> ()]()
        // when testing objects collaborating, asserting the values passed is not enough. we also need to ask "how many times was the method invoked?"
        
        func get(from url: URL, completion: @escaping (Error) -> ()) {
            completions.append(completion)
            requestedURLs.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
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
