//
//  Item.swift
//  eBaySearch
//
//  Created by Rick Li on 11/24/23.
//

import Foundation

struct Item: Decodable, Hashable, Encodable {
    let _id: String
    let id: String
//    let itemId: String
    let image: String
    let title: String
    let price: String
    let shippingCost: String
    let zipcode: String
    let condition: String
    let __v:Int
}
