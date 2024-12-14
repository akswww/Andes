//
//  SingletonOfPatient.swift
//  Smart care bedside display system
//
//  Created by imac-3570 on 2023/10/2.
//

import Foundation

class SingletonOfPatient {
    
    public static let shared = SingletonOfPatient()

    public var name: String = ""
    
    public var gender: Int = 0
    
    public var medicalRecordNumber: String = ""
    
    public var medicalRecordID: Int = 0
    
    public var wardNumber: String = ""

    public var birthday: String = ""
    
    public var bedNumber: Int = 0
    
    public var medication: [String] = []
    
    public var notice: [String] = []
    
    public var cases: [String] = []
    
    public var account: String = ""
    
    /// 將 Singleton 重設回預設值
    public func reset() {
        name = ""
        gender = 0
        medicalRecordNumber = ""
        medicalRecordID = 0
        wardNumber = ""
        birthday = ""
        bedNumber = 0
        medication = []
        notice = []
        cases = []
    }
}
