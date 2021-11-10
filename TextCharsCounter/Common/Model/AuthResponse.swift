//
//  AuthResponse.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import Foundation

struct AuthResponse: Codable {
    let success: Bool
    let data: DataClass
    //    let errors: [String]
}

struct DataClass: Codable {
    let status: Int
    let uid: Int
    let role: Int
    let createdAt: Int
    let email: String
    let updatedAt: Int
    let accessToken: String
    let name: String
    
    private enum CodingKeys : String, CodingKey {
        case status
        case uid
        case role
        case createdAt = "created_at"
        case email, updatedAt = "updated_at"
        case accessToken = "access_token"
        case name
    }
}

