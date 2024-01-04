//
//  RemoteImage.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/4/23.
//

import SwiftUI

struct RemoteImage: View {
    var imageUrl: String
    var imageSize: Double
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        } placeholder: {
            ProgressView()
        }
    }
}
//
//#Preview {
//    RemoteImage()
//}
