//
//  Items.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/4/23.
//

import Foundation

class Items: ObservableObject {
    @Published var items: [Item] = []
}
