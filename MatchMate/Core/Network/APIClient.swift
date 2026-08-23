//
//  APIClient.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation

protocol APIClient {
    func fetchProfiles(
        page: Int,
        results: Int
    ) async throws -> RandomUserResponse
}

final class URLSessionAPIClient: APIClient {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProfiles(
        page: Int,
        results: Int
    ) async throws -> RandomUserResponse {

        var components = URLComponents(
            string: "https://randomuser.me/api/"
        )

        components?.queryItems = [
            URLQueryItem(
                name: "page",
                value: "\(page)"
            ),
            URLQueryItem(
                name: "results",
                value: "\(results)"
            ),
            URLQueryItem(
                name: "seed",
                value: "matchmate"
            )
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        do {

            let (data, response) =
                try await session.data(from: url)

            guard let httpResponse =
                    response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.httpError(
                    httpResponse.statusCode
                )
            }

            do {
                return try JSONDecoder().decode(
                    RandomUserResponse.self,
                    from: data
                )
            } catch {
                throw APIError.decodingError
            }

        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
