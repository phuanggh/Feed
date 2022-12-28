//
//  SharedTestHelpers.swift
//  FeedTests
//
//  Created by Penny Huang on 2022/12/28.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    URL(string: "http://another-url.com")!
}
