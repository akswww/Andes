//
//  UserPreference.swift
//  Smart care bedside display system
//
//  Created by imac-3570 on 2023/11/20.
//

import Foundation

class UserPreferences {
    static let shared = UserPreferences()
    private let userPreferance: UserDefaults
    private init() {
        userPreferance = UserDefaults.standard
    }
    
    enum UserPreference: String {
        case name
        case token
        case tall
        case weight
        case birther
        case idcard
        case networkPath
        case gender
        case photebinary
        case clinic
        case currentSelectedIndices
    }
    
    var name: String {
        get { return userPreferance.string( forKey: UserPreference.name.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.name.rawValue)}
    }
    
    var tall: String {
        get { return userPreferance.string( forKey: UserPreference.tall.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.tall.rawValue)}
    }
    
    var weight: String {
        get { return userPreferance.string( forKey: UserPreference.weight.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.weight.rawValue)}
    }
    
    var birther: String {
        get { return userPreferance.string( forKey: UserPreference.birther.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.birther.rawValue)}
    }
    
    var idcard: String {
        get { return userPreferance.string( forKey: UserPreference.idcard.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.idcard.rawValue)}
    }
  
    var gender: String {
        get { return userPreferance.string( forKey: UserPreference.gender.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.gender.rawValue)}
    }
    
    var networkPath: String {
        get { return userPreferance.string( forKey: UserPreference.networkPath.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.networkPath.rawValue)}
    }
    
    var token: String {
        get { return userPreferance.string( forKey: UserPreference.token.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.token.rawValue)}
    }
    
    var photebinary: String {
        get { return userPreferance.string( forKey: UserPreference.photebinary.rawValue) ?? ""}
        set { return userPreferance.set( newValue, forKey: UserPreference.photebinary.rawValue)}
    }
    
    var clinic: [String] {
        get { return userPreferance.stringArray( forKey: UserPreference.photebinary.rawValue) ?? []}
        set { return userPreferance.set( newValue, forKey: UserPreference.photebinary.rawValue)}
    }
    var currentSelectedIndices: [Int] {
        get {
            return userPreferance.array(forKey: UserPreference.currentSelectedIndices.rawValue) as? [Int] ?? []
        }
        set { return userPreferance.set( newValue, forKey: UserPreference.currentSelectedIndices.rawValue)}
    }

}
