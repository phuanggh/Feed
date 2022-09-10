//
//  RemoteFeedLoader.swift
//  Feed
//
//  Created by Penny Huang on 2022/8/18.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    // the RemoteFeedLoader does not need to locate or instantiate the HTTPClient instance, so we make our code more modular by injecting a HTTPClient as a dependency
    // When you use singlnton for convenience of finding an instance of a type, it is often considered n anti-pattern
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> ()) {
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.failure(.connectivity))
            case let .success(data, response):
                do {
                    let items = try FeedItemMapper.map(data, response: response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
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

private class FeedItemMapper {
    private struct Root: Decodable {
        let items: [Item]
    }
    // when decoding received Data, convert it to the local representation Item type,
    // and then mapping it to FeedItem to be used in other part of the programme.
    // so the FeedItem has no knowledge of the API
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }

    static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return try JSONDecoder().decode(Root.self, from: data).items.map{ $0.item }
    }
}
