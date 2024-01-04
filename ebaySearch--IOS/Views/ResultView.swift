//
//  ResutlView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ResultView: View {
    @State var favorites: [Item] = []
    @Binding var items: [Item]
    @Binding var showToast:Bool
    @Binding var toasText: String
    @Binding var isLoading: Bool
    
    var keyword: String
    
    var body: some View {
        List{
            Text("Results")
                .font(.title)
                .fontWeight(.bold)
            if isLoading  {
                VStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).id(UUID())
                        
                    Text("Please wait...")
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            else{
                if items == [] {
                    Text("No results found.")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: ProductView(item: item, keyword:keyword, favorites: $favorites)) {
                            ItemView(item: item)
                            if favorites.contains(where: { $0.id == item.id }) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        Task{
                                            await removeFromFavorites(itemId: item.id)
                                            favorites.removeAll { $0.id == item.id }
                                            withAnimation {
                                                self.toasText = "Removed from favorites"
                                                self.showToast = true
                                            }
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
                                            withAnimation {
                                                self.toasText = "Added to favorites"
                                                self.showToast = true
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await getFavorites()
        }
    }
    
    
    func getFavorites() async{
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
    
    
    
    
    
    //    func removeFromFavorites() async {
    //            guard let url = URL(string: Constants.Urls.fetchFavorites) else { return }
    //            URLSession.shared.dataTask(with: url) { data, response, error in
    //                guard let data = data else { return }
    //                do {
    //                    let decodedFavorites = try JSONDecoder().decode([Item].self, from: data)
    //                    DispatchQueue.main.async {
    //                        self.favorites = decodedFavorites
    //                        print(favorites)
    //                    }
    //                } catch {
    //                    print(error.localizedDescription)
    //                }
    //            }.resume()
    //        }
}
//    #Preview {
//        ResutlView()
//    }
