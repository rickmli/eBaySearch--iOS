//
//  ProductInfoView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ProductInfoView: View {
    let itemDetails: ItemDetails
    
    var body: some View {
        VStack{
            ImageSliderView(images: itemDetails.images)
                .frame(width: 300, height: 300)
            Text(itemDetails.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("$\(itemDetails.price)")
                .frame(alignment: .leading)
                .foregroundStyle(.blue)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Image(systemName: "magnifyingglass")
                    .frame(height: 70)
                Text("Description")
            }.frame(maxWidth: .infinity, alignment: .leading)
            ScrollView{
                DescriptionsView(descriptions: itemDetails.descriptions)
            }
        }.padding()
    }
}

//#Preview {
//    ProductInfoView()
//}
