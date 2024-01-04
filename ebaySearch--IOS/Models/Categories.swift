//
//  Category.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

struct Category: Identifiable {
    let id: String?
    let name: String
}

struct Categories {
    static let all: [Category] = [
        Category(id: "", name: "All"),
        Category(id: "550", name: "Art"),
        Category(id: "2984", name: "Baby"),
        Category(id: "267", name: "Books"),
        Category(id: "11450", name: "Clothing, Shoes & Accessories"),
        Category(id: "58058", name: "Computers/Tablets & Networking"),
        Category(id: "26395", name: "Health & Beauty"),
        Category(id: "11233", name: "Music"),
        Category(id: "1249", name: "Video Games & Consoles")
    ]
}
