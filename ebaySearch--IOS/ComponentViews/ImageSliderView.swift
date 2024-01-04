//
//  ImageSlider.swift
//  eBaySearch
//
//  Created by Rick Li on 11/25/23.
//

import SwiftUI

struct ImageSliderView: View {
    let images: [String]

//    private let images = ["https://i.ebayimg.com/00/s/NTAwWDUwMA==/z/sigAAOSw8wVhab-t/$_57.JPG?set_id=8800005007", "https://i.ebayimg.com/thumbs/images/g/GssAAOSwh4plTqNo/s-l140.jpg"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { item in
                AsyncImage(url: URL(string: item)) { image in
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            setupAppearance()
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
}
//
//#Preview(traits: .sizeThatFitsLayout) {
//    ImageSliderView()
//        .frame(height: 300)
////        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//}
