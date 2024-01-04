//
//  FormInputs.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import Foundation
import CoreLocation

class FormInputs: ObservableObject {

    @Published var keyword: String = ""
    @Published var category: String = ""
    @Published var isUsed: Bool = false
    @Published var isNew: Bool = false
    @Published var isUnspecified: Bool = false
    @Published var isPickup: Bool = false
    @Published var isFreeShipping: Bool = false
    @Published var distance: String = ""
    @Published var isCustomLocation: Bool = false
    @Published var currentZipcode: String = ""
    @Published var customeZipcode: String = ""
}
