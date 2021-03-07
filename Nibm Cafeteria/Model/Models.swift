//
//  Models.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import Foundation

struct FoodItem {
    
    var imgFood : String
    var foodName : String
    var foodInfo : String
    var foodPrice : Double
    var foodDiscount : Int
    var discountedPrice : Double {
        return foodPrice - (foodPrice * Double(foodDiscount)/100)
    }
    
}

struct Catogery {
    var categoryName : String
    var isSelected : Bool
}
