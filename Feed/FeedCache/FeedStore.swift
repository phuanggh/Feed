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
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
