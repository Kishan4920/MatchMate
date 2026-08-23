//
//  Endpoint.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation

enum Endpoint {
    case randomUsers(count: Int)

    var request: URLRequest? {
        switch self {
        case .randomUsers(let count):
            var components = URLComponents(string: "https://randomuser.me/api/")
            components?.queryItems = [URLQueryItem(name: "results", value: String(count))]
            guard let url = components?.url else { return nil }
            return URLRequest(url: url)
        }
    }
}
