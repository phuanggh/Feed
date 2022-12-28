//
//  FeedLoader.swift
//  Feed
//
//  Created by Penny Huang on 2022/8/12.
//

import Foundation

//typealias LoadFeedResult = Result<FeedItem, Error>

// use XCAssertEqual force this enum to conform to Equatable
public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> ())
}
