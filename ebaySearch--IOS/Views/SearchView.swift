//
//  SearchView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct SearchView: View {
    
    var body: some View {
        NavigationView{
            FormView()
                .navigationBarTitle("Product Search")
                .navigationBarItems(
                    trailing:
                        NavigationLink(destination: FavoriteView()) {
                            Image(systemName: "heart.circle")
                                .foregroundColor(.blue)
                        }
                )
        }
    }
}

#Preview {
    SearchView()
}
