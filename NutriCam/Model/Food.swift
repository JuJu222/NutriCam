//
//  Food.swift
//  TryEdamamAPI
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import Foundation

// MARK: - Food
struct Food: Codable {
    var text: String?
    var parsed: [Parsed]?
    var hints: [Hint]?
    var links: Links?
}

// MARK: - Parsed
struct Parsed: Codable, Hashable {
    static func == (lhs: Parsed, rhs: Parsed) -> Bool {
        lhs.food == rhs.food
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(food)
    }
    
    var food: ParsedFood?
}

// MARK: - ParsedFood
struct ParsedFood: Codable, Hashable {
    static func == (lhs: ParsedFood, rhs: ParsedFood) -> Bool {
        lhs.foodId == rhs.foodId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(foodId)
    }
    
    var foodId: String?
    var label: String?
    var knownAs: String?
    var nutrients: Nutrients?
    var category: String?
    var categoryLabel: String?
    var image: String?
}

// MARK: - Hint
struct Hint: Codable, Hashable {
    static func == (lhs: Hint, rhs: Hint) -> Bool {
        lhs.food == rhs.food
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(food)
    }
    
    var food: HintFood?
    var measures: [Measure]?
}

// MARK: - HintFood
struct HintFood: Codable, Hashable {
    static func == (lhs: HintFood, rhs: HintFood) -> Bool {
        lhs.foodId == rhs.foodId && lhs.label == rhs.label
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(foodId)
    }
    
    var foodId, label, knownAs: String?
    var nutrients: Nutrients?
    var category: String?
    var categoryLabel: String?
    var image: String?
    var foodContentsLabel, brand: String?
    var servingSizes: [ServingSize]?
}

//enum Category: String {
//    case genericFoods
//    case genericMeals
//    case packagedFoods
//}
//
//enum CategoryLabel: String {
//    case food
//    case meal
//}

// MARK: - Nutrients
struct Nutrients: Codable {
    var ENERC_KCAL, PROCNT, FAT, CHOCDF: Double?
    var FIBTG: Double?
}

// MARK: - ServingSize
struct ServingSize: Codable {
    var uri: String?
    var label:  String?
    var quantity: Double?
}

//enum Label: String {
//    case cup
//    case gram
//    case kilogram
//    case milliliter
//    case ounce
//    case package
//    case pie
//    case pizza
//    case pound
//    case serving
//    case slice
//    case whole
//}

// MARK: - Measure
struct Measure: Codable, Hashable {
    static func == (lhs: Measure, rhs: Measure) -> Bool {
        lhs.label == rhs.label
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
    
    var uri: String?
    var label: String?
    var weight: Double?
    var qualified: [Qualified]?
}

// MARK: - Qualified
struct Qualified: Codable {
    var qualifiers: [Qualifier]?
    var weight: Int?
}

// MARK: - Qualifier
struct Qualifier: Codable {
    var uri: String?
    var label: String?
}

// MARK: - Links
struct Links: Codable {
    var next: Next?
}

// MARK: - Next
struct Next: Codable {
    var title: String?
    var href: String?
}
