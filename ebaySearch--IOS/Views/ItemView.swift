//
//  ResultCellView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ItemView: View {
    let item: Item
//    @Binding var favorites: [Item]
    @State private var canDelete: Bool = true
    
    var body: some View {
        HStack{
            RemoteImage(imageUrl: item.image, imageSize: 100)
            VStack {
                Text(item.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.bold)
                Text("$\(item.price)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
                Text(item.shippingCost != "FREE SHIPPING" ? "$" + item.shippingCost : item.shippingCost)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                HStack{
                    Text(item.zipcode)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(item.condition)
                        .foregroundColor(.gray)
                }
            }
            //        }.padding([.top, .bottom], 8)
        }
    }
}

//#Preview {
//    ResultCellView()
//}
