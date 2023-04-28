//
//  MusicData.swift
//  NetworkAndURLSession
//
//  Created by july on 2023/4/27.
//

import SwiftUI


class Order: ObservableObject,Codable { // 用 class 系统会临时保存数据，当你在页面之间跳转
    // MARK: - ObservaleObject does not conform to protocol 'Encodable',so manually let it conform to Codable
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, street, city, zip
    }
    
    init() {} //fix error: Missing argument for parameter 'from' in call
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(street, forKey: .street)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
        
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        street = try container.decode(String.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
        
    }
    
    
    
    static let types = ["v","s","c","r"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var street = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || street.isEmpty || street.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        //$2 per cake
        var cost = Double(quantity)*2
        
        //complicated cakes cost more
        cost += (Double(type)/2)
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
    
}
