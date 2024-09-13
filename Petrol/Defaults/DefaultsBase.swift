//
//  DefaultsBase.swift
//  Petrol
//
//  Created by Ben Robinson on 11/09/2024.
//

import Foundation

class Defaults: NSObject {
    
    static let fuel = FuelDefaults()
    
}

class DefaultsObjectBase<T> {
    
    private let defaults: UserDefaults = UserDefaults.standard
    
    private func keyString(_ key: T) -> String {
        let parent = String(String(describing: self).split(separator: ".").last ?? "")
        return "\(parent).\(String(describing: key))"
    }
    
    
    //Set Functions
    
    func setOrRemove(_ value: String, forKey key: T) {
        if value.isEmpty {
            remove(forKey: key)
        } else {
            defaults.set(value, forKey: keyString(key))
        }
    }
    
    
    //Get Functions
    
    func stringOrNil(forKey key: T) -> String? {
        return defaults.string(forKey: keyString(key))
    }
    
    
    //Remove
    
    func remove(forKey key: T) {
        defaults.removeObject(forKey: keyString(key))
    }
}
