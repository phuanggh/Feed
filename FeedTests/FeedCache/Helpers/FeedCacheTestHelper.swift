//
//  FeedCacheTestHelper.swift
//  FeedTests
//
//  Created by Penny Huang on 2022/12/28.
//

import Foundation
import Feed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (models, local)
}

// cache policy
extension Date {
    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        7
    }
    
    private func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: -7, to: self)!
    }
}

// helper
extension Date {
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}

