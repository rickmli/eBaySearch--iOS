//
//  ItemDictionary.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/5/23.
//

import Foundation

struct ItemDictionary: Encodable {
    let id: String
    let image: String
    let title: String
    let price: String
    let shippingCost: String
    let zipcode: String
    let condition: String
    // Add other properties as needed

    init(item: Item) {
        self.id = item.id
        self.image = item.image
        self.title = item.title
        self.price = item.price
        self.shippingCost = item.shippingCost
        self.zipcode = item.zipcode
        self.condition = item.condition
        // Initialize other properties as needed
    }
}
