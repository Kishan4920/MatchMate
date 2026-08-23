//
//  RandomUserDTO.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation

struct RandomUserDTO: Decodable {
    let gender: String
    let name: NameDTO
    let location: LocationDTO
    let email: String
    let login: LoginDTO
    let dob: DOBDTO
    let registered: RegisteredDTO
    let phone: String
    let picture: PictureDTO
    let nationality: String

    enum CodingKeys: String, CodingKey {
        case gender
        case name
        case location
        case email
        case login
        case dob
        case registered
        case phone
        case picture
        case nationality = "nat"
    }
}

struct NameDTO: Decodable {
    let title: String
    let first: String
    let last: String
}

struct LocationDTO: Decodable {
    let city: String
    let state: String
    let country: String
}

struct LoginDTO: Decodable {
    let uuid: String
}

struct DOBDTO: Decodable {
    let date: String
    let age: Int
}

struct RegisteredDTO: Decodable {
    let date: String
    let age: Int
}

struct PictureDTO: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
