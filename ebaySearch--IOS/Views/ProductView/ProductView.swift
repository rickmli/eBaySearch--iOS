//
//  ProductView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ProductView: View {
    let item: Item
    let keyword: String
    @Binding var favorites: [Item]
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLoading: Bool = false
    @State var itemDetails = ItemDetails(
        id: "",
        images: [],
        url: "",
        title: "",
        price: "",
        descriptions: [],
        storeName: "",
        storeURL: "",
        popularity: "",
        feedbackScore: "",
        shippingCost: "",
        isGlobalShipping: "",
        handlingTime: "",
        policy: "",
        refundMode: "",
        returnsWithin: "",
        shippingCostPaidBy: ""
    )
    
    var body: some View {
        NavigationView{
                TabView {
                    VStack{
                        if isLoading  {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle()).id(UUID())
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ProductInfoView(itemDetails: itemDetails)
                        }
                    }
                        .tabItem {
                            Label("Info", systemImage: "info.circle.fill")
                        }
                    VStack{
                        if isLoading  {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle()).id(UUID())
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ProductShippingView(itemDetails: itemDetails)}
                    }
                        .tabItem {
                            Label("Shipping", systemImage: "shippingbox.fill")
                        }
                    ProductPhotoView(keyword: keyword)
                        .tabItem {
                            Label("Photos", systemImage: "photo.stack.fill")
                        }
                    ProductSimilarView(itemId: item.id)
                        .tabItem {
                            Label("Similar", systemImage: "list.bullet.indent")
                        }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Product search")
                            }
                        }
                    }
                }
                .navigationBarItems(
                    trailing:
                        HStack{
                            Button(action: {
                                openFacebookShare(link: itemDetails.url)
                            }) {
                                Image("facebookLogo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            Text("")
                                .padding([.leading, .trailing], 1)
                            
                            if favorites.contains(where: { $0.id == item.id }) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        Task{
                                            await removeFromFavorites(itemId: item.id)
                                            favorites.removeAll { $0.id == item.id }
                                        }
                                        
                                    }
                            } else {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        Task{
                                            await addToFavorites(item: item)
                                            favorites += [item]
                                        }
                                    }
                            }
                        }
                )
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                Task{
                    await getItemDetails()
                }
            }
        
    }
    
    func getItemDetails() async {
        isLoading = true
        guard let url = URL(string: "\(Constants.Urls.fetchItemInfos)itemId=\(item.id)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedItemDetails = try JSONDecoder().decode(ItemDetails.self, from: data)
                DispatchQueue.main.async {
                    self.itemDetails = decodedItemDetails
                }
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                isLoading = false
            }
        }.resume()
    }
    
    func addToFavorites(item: Item) async {
        guard let url = URL(string: Constants.Urls.fetchFavorites) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Create an instance of ItemDictionary
            let itemDictionary = ItemDictionary(item: item)
            
            // Encode the itemDictionary to Data
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(itemDictionary)
            
            request.httpBody = bodyData
        } catch {
            print("Error encoding item:", error.localizedDescription)
            return
        }
        
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
    func openFacebookShare(link: String) {
        guard let facebookURL = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(link)") else {
            return
        }
        
        // Open Safari with the Facebook share link
        UIApplication.shared.open(facebookURL)
    }
}

//#Preview {
//    ProductView()
//}
