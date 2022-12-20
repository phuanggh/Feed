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
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
