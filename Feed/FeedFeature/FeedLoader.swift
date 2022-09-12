//
//  FeedLoader.swift
//  Feed
//
//  Created by Penny Huang on 2022/8/12.
//

import Foundation

//typealias LoadFeedResult = Result<FeedItem, Error>

// use XCAssertEqual force this enum to conform to Equatable
public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable {
    
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> ())
}
