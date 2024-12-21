//
//  clinic.swift
//  AndesCompetition
//
//  Created by imac-3570 on 12/18/24.
//

import Foundation

struct ClinicRequest: Codable {
    var appointment_clinic: Appointment_clinic
}

struct Appointment_clinic: Codable {
    var first: [String]
    var second: [String]
    var third: [String]
}
