//
//  FeedItemMapper.swift
//  Feed
//
//  Created by Penny Huang on 2022/9/10.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

internal final class FeedItemMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    // when decoding received Data, convert it to the local representation Item type,
    // and then mapping it to FeedItem to be used in other part of the programme.
    // so the FeedItem has no knowledge of the API


    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
