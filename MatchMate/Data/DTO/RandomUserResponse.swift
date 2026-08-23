//
//  RandomUserResponse.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//
import Foundation

struct RandomUserResponse: Decodable {
    let results: [RandomUserDTO]
    let info: APIInfo
}

struct APIInfo: Decodable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}
