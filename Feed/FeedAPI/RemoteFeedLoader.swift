//
//  RemoteFeedLoader.swift
//  Feed
//
//  Created by Penny Huang on 2022/8/18.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    // the RemoteFeedLoader does not need to locate or instantiate the HTTPClient instance, so we make our code more modular by injecting a HTTPClient as a dependency
    // When you use singlnton for convenience of finding an instance of a type, it is often considered n anti-pattern
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> ()) {
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.connectivity)
            case .success:
                completion(.invalidData)
            }
        }
        // problems of using a shared instance ->
            // 1. mixing the responsibility of invoking a method in an object
            // 2. the reponsibility of locating this object. I know how to locate this object in memory, I know what instance I'm using, but I don't need to know them
        // if we inject our client, we have more control over our code
        // the HTTPClient has no reason to be a sinlgeton. To justy the creation of a singleton, you need to have a good reason, for example, you only want to have 1 HTTPClient per application.
        
        // is it the responsibility of this FeedLoader to know which URL it is getting data from, or it is given this URL?
        // -> we don't know, and we don't care about it. let's why it can be injected
    }
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> ())
}
