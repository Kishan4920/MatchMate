//
//  MockAPIClient.swift
//  MatchMateTests
//
//  Created by Kishan Patel on 24/08/26.
//

@testable import MatchMate

struct MockAPIClient: APIClient {
    var response: RandomUserResponse = .sample

    func fetchProfiles(page: Int, results: Int) async throws -> RandomUserResponse {
        response
    }
}

private extension RandomUserResponse {
    static let sample = RandomUserResponse(
        results: [
            RandomUserDTO(
                gender: "female",
                name: NameDTO(title: "Ms", first: "Ada", last: "Lovelace"),
                location: LocationDTO(city: "London", state: "England", country: "United Kingdom"),
                email: "ada@example.com",
                login: LoginDTO(uuid: "profile-1"),
                dob: DOBDTO(date: "1990-01-01T00:00:00.000Z", age: 36),
                registered: RegisteredDTO(date: "2020-01-01T00:00:00.000Z", age: 6),
                phone: "+44 0000 000000",
                picture: PictureDTO(
                    large: "https://example.com/large.jpg",
                    medium: "https://example.com/medium.jpg",
                    thumbnail: "https://example.com/thumb.jpg"
                ),
                nationality: "GB"
            )
        ],
        info: APIInfo(seed: "matchmate", results: 1, page: 1, version: "1.0")
    )
}
