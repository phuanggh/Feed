//
//  FeedStore.swift
//  Feed
//
//  Created by Penny Huang on 2022/12/20.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (NSError?) -> ()
    typealias InsertionCompletion = (NSError?) -> ()
    typealias RetrievalCompletion = (NSError?) -> ()
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
