//
//  GetTextRequest.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import Foundation

struct GetTextRequest: Requestable {
    var parameters: GetTextRequestParameters
    var path: String = "/api/get/text/"
    var method: HTTPMethod { .get }

    func urlRequest(baseURL: URL) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL),
              let accessToken = KeyChain.shared["token"] // need to specify error as token issue
        else {
            throw DataResponseError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        return request.encode(with: parameters.paramsDict)
    }
}

struct GetTextRequestParameters {
    var locale: String
    var paramsDict: [String: String] {
        ["locale": locale]
    }
}

