//
//  RemoteFeedItem.swift
//  Feed
//
//  Created by Penny Huang on 2022/12/20.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
