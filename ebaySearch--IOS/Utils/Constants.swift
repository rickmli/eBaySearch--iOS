//
//  Constants.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import Foundation

struct Constants {
    struct Urls {
        // hosting on google app engine
        // static let backendUrl = "https://ebaysearch-404316.df.r.appspot.com"
        
        // hosting locally
        static let backendUrl = "http://localhost:8080"
        
        static let fetchItems = "\(backendUrl)/eBay/advanceSearch?"
        static let fetchItemInfos = "\(backendUrl)/eBay/getSingleItem?"
        static let fetchPhotos = "\(backendUrl)/google/customSearch?"
        static let fetchSimilarItems = "\(backendUrl)/eBay/getSimilarItems?"
        static let fetchCurrentPosition = "https://ipinfo.io/json?token=6a27e2241d695a"
        static let fetchOptions = "\(backendUrl)/autoComplete?"
        static let fetchFavorites = "\(backendUrl)/shoppingCart"
    }
}
