//
//  Brands.swift
//  Petrol
//
//  Created by Ben Robinson on 12/09/2024.
//

import Foundation
import SwiftUI

struct Brand {
    var name: String?
    var image: String
    var bgColour: UIColor
}

class Brands {
    
    var BrandList: [Brand] = []
    var DefaultBrand = Brand(image: "default-sign", bgColour: UIColor(red: 0, green: 0.47451, blue: 0.75686, alpha: 1))
    
    init() {
        self.BrandList = [
            Brand(name: "Applegreen", image: "brand-applegreen", bgColour: UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)),
            Brand(name: "ASDA", image: "brand-asda", bgColour: .white),
            Brand(name: "BP", image: "brand-bp", bgColour: .white),
            Brand(name: "Co-op", image: "brand-coop", bgColour: .white),
            Brand(name: "Essar", image: "brand-essar", bgColour: .white),
            Brand(name: "Esso", image: "brand-esso", bgColour: .white),
            Brand(name: "Gulf", image: "brand-gulf", bgColour: .white),
            Brand(name: "Harvest Energy", image: "brand-harvest-energy", bgColour: .white),
            Brand(name: "JET", image: "brand-jet", bgColour: UIColor(red: 1, green: 0.810, blue: 0.225, alpha: 1)),
            Brand(name: "Morrisons", image: "brand-morrisons", bgColour: .white),
            Brand(name: "Murco", image: "brand-murco", bgColour: UIColor(red: 0.899, green: 0.091, blue: 0.213, alpha: 1)),
            Brand(name: "Sainsbury's", image: "brand-sainsburys", bgColour: UIColor(red: 0.94, green: 0.424, blue: 0.006, alpha: 1)),
            Brand(name: "Shell", image: "brand-shell", bgColour: .white),
            Brand(name: "Tesco", image: "brand-tesco", bgColour: .white),
            Brand(name: "Texaco", image: "brand-texaco", bgColour: .white),
        ].compactMap( { $0 } )
    }
    
    func findBy(name: String) -> Brand {
        BrandList.first(where: { $0.name?.lowercased() == name.lowercased().trim() }) ?? DefaultBrand
    }
}

