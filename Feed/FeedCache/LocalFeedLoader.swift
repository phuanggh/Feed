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
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> ()) {
        // we can see that LocalFeedLoader is invoking more than 1 method in "store" dependency.
        // Aside from checking the methods we invoke,
        // It's important to check those methods are invoked in the right order
        store.deleteCacheFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> ()) {
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        map { LocalFeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.imageURL) }
    }
}
