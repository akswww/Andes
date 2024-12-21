//
//  Login.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/19.
//

import Foundation

struct LoginRequest: Codable {
    var username: String
    var password: String
}

struct LoginReponse: Codable {

    var data: Result1
    var result: Int
}

struct Result1: Codable {
    var token: String
}
struct BaseReponse: Codable {
   
    var result: Int
    
    var message: String
}

struct measureReponse: Codable {

    var measure: Measure
    var result: Int
}

struct Measure: Codable {
   
    var temperature: Double
    
    var pulse: Int
}
