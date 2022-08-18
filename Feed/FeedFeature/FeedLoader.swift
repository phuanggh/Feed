//
//  FeedLoader.swift
//  Feed
//
//  Created by Penny Huang on 2022/8/12.
//

import Foundation

typealias LoadFeedResult = Result<FeedItem, Error>

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> ())
}
