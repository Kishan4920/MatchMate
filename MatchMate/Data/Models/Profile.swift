//
//  Profile.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation

struct Profile: Identifiable, Equatable, Hashable {
    let id: String

    let title: String
    let firstName: String
    let lastName: String

    let gender: String
    let email: String
    let phone: String

    let age: Int
    let dateOfBirth: Date?
    let registeredDate: Date?

    let city: String
    let state: String
    let country: String
    let nationality: String

    let largeImageURL: String
    let mediumImageURL: String
    let thumbnailImageURL: String

    var status: ProfileStatus

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
