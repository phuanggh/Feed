//
//  LocalFeedLoader.swift
//  Feed
//
//  Created by Penny Huang on 2022/12/20.
//

import Foundation

// LocalFeedLoader interface
//      確保delete時FeedStore (與DB溝通)會執行一次delete
//      確保delete時FeedStore (與DB溝通)得到的error會傳回LocalFeedLoader，並做相對應的處理
//      確保save時FeedStore (與DB溝通)會執行一次save
public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> ()) {
        // we can see that LocalFeedLoader is invoking more than 1 method in "store" dependency.
        // Aside from checking the methods we invoke,
        // It's important to check those methods are invoked in the right order
        store.deleteCacheFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load() {
        store.retrieve()
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> ()) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
