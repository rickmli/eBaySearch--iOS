//
//  CurrentPosition.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import Foundation

struct CurrentPosition: Decodable {
    let ip: String
    let hostname: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
}
