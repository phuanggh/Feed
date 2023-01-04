//
//  FeedCachePolicy.swift
//  Feed
//
//  Created by Penny Huang on 2023/1/4.
//

import Foundation

// you can make it a struct, since it requires no identity or shared state
// or enum. An enum with no cases doesn't require an initialiser
internal final class FeedCachePolicy {
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int { 7 }
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false}
        return date < maxCacheAge
    }
}
