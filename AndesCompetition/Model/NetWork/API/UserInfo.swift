//
//  UserInfo.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/22.
//

import Foundation

struct UserInfoRequest: Codable {
    var name: String
    var height: Double
    var gender: Bool
    var weight: Double
    var birthday: String
    var national_id: String
}


