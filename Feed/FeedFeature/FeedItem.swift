//
//  FeedItem.swift
//  Feed
//
//  Created by Penny Huang on 2022/8/12.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let url: URL
}
