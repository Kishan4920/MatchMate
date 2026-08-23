//
//  APIError.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation

enum APIError: LocalizedError {

    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case networkError(Error)

    var errorDescription: String? {

        switch self {
        case .invalidURL:
            return "Invalid URL."

        case .invalidResponse:
            return "Invalid server response."

        case .httpError(let code):
            return "Server returned error \(code)."

        case .decodingError:
            return "Unable to read server data."

        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
