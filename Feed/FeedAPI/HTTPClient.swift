//
//  HTTPClient.swift
//  Feed
//
//  Created by Penny Huang on 2022/9/10.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> ())
}
