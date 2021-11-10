//
//  Requestable.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import Foundation

protocol Requestable {
    var path: String { get }
    var method: HTTPMethod { get }
    // params
    // headers
    
    func urlRequest(baseURL: URL) throws -> URLRequest
}
