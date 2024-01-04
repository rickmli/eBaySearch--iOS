//
//  ProductPhotoView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ProductPhotoView: View {
    let keyword:String
    @State var itemPhotos:[String] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack{
            if isLoading  {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).id(UUID())
                        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .center)
            } else {
                HStack{
                    Text("Powered by")
                    Image("googleLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                }
                ScrollView {
                    ForEach(itemPhotos, id: \.self) { photo in
                        AsyncImage(url: URL(string: photo)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }.task {
            await getItemPhotos()
        }
    }
    
    func getItemPhotos() async {
        isLoading = true
        guard let url = URL(string: "\(Constants.Urls.fetchPhotos)keyword=\(keyword)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedItemPhotos = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    self.itemPhotos = decodedItemPhotos
                }
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                            isLoading = false
                        }
        }.resume()
    }
}

//#Preview {
//    ProductPhotoView()
//}
