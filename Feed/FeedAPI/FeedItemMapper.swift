//
//  FeedItemMapper.swift
//  Feed
//
//  Created by Penny Huang on 2022/9/10.
//

import Foundation

internal class FeedItemMapper {
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

    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return try JSONDecoder().decode(Root.self, from: data).items.map{ $0.item }
    }
}
