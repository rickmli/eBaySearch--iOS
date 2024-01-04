//
//  ProductSimilarView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ProductSimilarView: View {
    let itemId:String
    
    @State var similarItems: [SimilarItem] = []
    
    @State private var sortType = "default"
    @State private var sortOrder = "ascending"
    @State private var isLoading: Bool = false
    
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 0)]
    
    var sortedItems: [SimilarItem] {
        switch sortType {
        case "default":
            return similarItems // No sorting needed for default
        case "name":
            return sortByTitle(\.title)
        case "price":
            return sortByNumbers(\.price)
        case "daysLeft":
            return sortByNumbers(\.daysLeft)
        case "shipping":
            return sortByNumbers(\.shippingCost)
        default:
            return similarItems
        }
    }
    
    var body: some View {

            VStack {
                if isLoading  {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle()).id(UUID())
                                        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .center)
                } else {
                    
                    VStack{
                        Text("Sort By")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("SortType", selection: $sortType) {
                            Text("Default").tag("default")
                            Text("Name").tag("name")
                            Text("Price").tag("price")
                            Text("Days Left").tag("daysLeft")
                            Text("Shipping").tag("shipping")
                        }
                        .pickerStyle(.segmented)
                        
                        if sortType != "default" {
                            VStack{
                                Text("Order")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("SortOrder", selection: $sortOrder) {
                                    Text("Ascending").tag("ascending")
                                    Text("Descending").tag("descending")
                                }
                                .pickerStyle(.segmented)}
                        }
                    }.padding()
                    
                    ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(sortedItems, id: \.id) { similarItem in
                            ZStack{
                                Rectangle()
                                    .fill(Color(red: 0.96, green: 0.97, blue: 0.95))
                                    .frame(width: 180, height: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.gray, lineWidth: 2)
                                    )
                                VStack{
                                    RemoteImage(imageUrl: similarItem.image, imageSize: 160).padding([.top], 40)
                                    VStack{
                                        Text(similarItem.title)
                                            .lineLimit(2)
                                        HStack{
                                            Text("$\(similarItem.shippingCost)")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12))
                                            Spacer()
                                            Text("\(similarItem.daysLeft) days left")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12))
                                        }
                                        Text("$\(similarItem.price)")
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            .font(.system(size: 24))
                                    }.padding(30)
                                }
                            }.padding(0)
                        }
                    }
                }
            }
        }.task {
            await getSimilarItems()
        }
    }
    func getSimilarItems() async {
        isLoading = true
        guard let url = URL(string: "\(Constants.Urls.fetchSimilarItems)itemId=\(itemId)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedSimilarItems = try JSONDecoder().decode([SimilarItem].self, from: data)
                DispatchQueue.main.async {
                    self.similarItems = decodedSimilarItems
                }
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                            isLoading = false
                        }
        }.resume()
    }
    
    func sortByTitle<T: Comparable>(_ keyPath: KeyPath<SimilarItem, T>) -> [SimilarItem] {
        return sortOrder == "ascending" ? similarItems.sorted(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] }) : similarItems.sorted(by: { $0[keyPath: keyPath] > $1[keyPath: keyPath] })
    }
    
    func sortByNumbers(_ keyPath: KeyPath<SimilarItem, String>) -> [SimilarItem] {
        return similarItems.sorted { (item1, item2) -> Bool in
            if let value1 = Double(item1[keyPath: keyPath]), let value2 = Double(item2[keyPath: keyPath]) {
                return sortOrder == "ascending" ? value1 < value2 : value1 > value2
            }
            // If the string cannot be converted to a numeric value, handle accordingly
            return false
        }
    }
}

//#Preview {
//    ProductSimilarView()
//}
