//
//  SignUpRequest.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import Foundation

struct SignUpRequest: Requestable {
    let parameters: SignUpRequestParameters
    var path: String { "/api/signup/" }
    var method: HTTPMethod { .post }
    
    func urlRequest(baseURL: URL) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw DataResponseError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters.paramsDict)
        request.httpBody = jsonData

        return request
    }
}

struct SignUpRequestParameters {
    var name: String
    var email: String
    var password: String
    var paramsDict: [String: String] {
        [
            "name": name,
            "email": email,
            "password": password
        ]
    }
}
