//
//  SimilarItem.swift
//  eBaySearch
//
//  Created by Rick Li on 11/26/23.
//

import Foundation

struct SimilarItem: Decodable {
    let id: String
    let image: String
    let price: String
    let title: String
    let shippingCost: String
    let daysLeft: String
}
