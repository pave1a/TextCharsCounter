//
//  NetworkAdditionalConfiguration.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import Foundation

// TODO: - Additional configurations. File must be split

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

// TODO: - need to rethink // decompose on client and network error options
enum DataResponseError: Error {
    case network
    case decoding
    case invalidURL
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data"
        case .decoding:
            return "An error occurred while decoding data"
        case .invalidURL:
            return "An error occurred due to url conversion"
        }
    }
}

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
