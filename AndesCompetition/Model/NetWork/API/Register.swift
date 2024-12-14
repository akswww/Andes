//
//  Register.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/19.
//

import Foundation

struct RegisterRequest: Codable {
    var username: String
    var password: String
}

struct RegisterReponse: Codable {
    var state: Int
    var result: Int
}
