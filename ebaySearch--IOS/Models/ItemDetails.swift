//
//  ItemInfo.swift
//  eBaySearch
//
//  Created by Rick Li on 11/24/23.
//
import Foundation

struct ItemDetails: Decodable {
    let id: String
    let images: [String]
    let url: String
    let title: String
    let price: String
    let descriptions: [Description]
    let storeName: String
    let storeURL: String
    let popularity: String
    let feedbackScore: String
    let shippingCost: String
    let isGlobalShipping: String
    let handlingTime: String
    let policy: String
    let refundMode: String
    let returnsWithin: String
    let shippingCostPaidBy: String
}

struct Description: Codable {
    let name: String
    let value: String
}
