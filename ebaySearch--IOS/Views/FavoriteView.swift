//
//  FavoriteView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct FavoriteView: View {
    @State var favorites: [Item] = []
    @State private var isLoading: Bool = false
    @State private var hasTimeElapsed = false
    
    var body: some View {
        VStack{
            if isLoading  {
                Text("Loading...")
            }
            else {
                if favorites.isEmpty {
                    Text("No items in wishlist")
                }
                else{
                    List{
                        HStack{
                            Text("Wishlist total(\(favorites.count)) items:")
                            Spacer()
                            Text("$\(calculateTotalPrice())")
                        }
                        
                        ForEach(favorites, id: \.self) { item in
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
                                    Text(item.shippingCost)
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
                            }.padding([.top, .bottom], 8)
                        }.onDelete(perform: delete)
                    }.navigationBarTitle("Favorites")
                }
            }
        }.onAppear{
            Task{
                await getFavorites()
            }
        }
    }
    
    func getFavorites() async {
        isLoading = true
        guard let url = URL(string: Constants.Urls.fetchFavorites) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedFavorites = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    self.favorites = decodedFavorites
                    print(favorites)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                isLoading = false
            }
        }.resume()
    }
    
    func removeFromFavorites(itemId: String) async {
        guard let url = URL(string: "\(Constants.Urls.fetchFavorites)?id=\(itemId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }
            
            do {
                let decodedFavorites = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    self.favorites = decodedFavorites
                    print(self.favorites)
                }
            } catch {
                print("Error decoding response:", error.localizedDescription)
            }
        }.resume()
    }
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let deletedItemId = favorites[index].id
            Task {await removeFromFavorites(itemId: deletedItemId)}
            favorites.removeAll { $0.id == deletedItemId }
        }
    }
    
    private func calculateTotalPrice() -> String {
        let total = favorites.reduce(0.0) { total, item in
            total + (Double(item.price) ?? 0.0)
        }
        return String(format: "%.2f", total)
    }
}


