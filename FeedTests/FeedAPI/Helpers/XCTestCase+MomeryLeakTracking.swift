//
//  XCTestCase+MomeryLeakTracking.swift
//  FeedTests
//
//  Created by Penny Huang on 2022/11/1.
//

import Foundation
import XCTest

extension XCTest {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        // run the assertions after all the tests are passed
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
