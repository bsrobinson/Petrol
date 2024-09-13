//
//  FuelTypeDefaults.swift
//  Petrol
//
//  Created by Ben Robinson on 11/09/2024.
//

import Foundation

enum FuelDefaultsKeys {
    case type
}

class FuelDefaults: DefaultsObjectBase<FuelDefaultsKeys>, ObservableObject {
    
    var type = "" {
        didSet { self.saveType() }
    }
    
    override init() {
        super.init()
        type = stringOrNil(forKey: .type) ?? "E10"
    }
    
    private func saveType() {
        setOrRemove(type, forKey: .type)
        objectWillChange.send()
    }
}
