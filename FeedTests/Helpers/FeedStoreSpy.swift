//
//  FeedStoreSpy.swift
//  FeedTests
//
//  Created by Penny Huang on 2022/12/22.
//

import Foundation
import Feed

class FeedStoreSpy: FeedStore {
    typealias DeletionCompletion = (NSError?) -> ()
    typealias InsertionCompletion = (NSError?) -> ()
    typealias RetrievalCompletion = (NSError?) -> ()
    
    enum ReceivedMessages:Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessages]()
    private var deletionCompletion = [DeletionCompletion]()
    private var insertionCompletion = [InsertionCompletion]()
    private var retrievalCompletion = [RetrievalCompletion]()
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion) {
        deletionCompletion.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletion[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletion[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletion.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionCompletion[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletion[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletion.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retrievalCompletion[index](error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletion[index](nil)
    }
}
