//
//  CheckboxToggleStyle.swift
//  eBaySearch
//
//  Created by Rick Li on 11/23/23.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    @Binding var boxChecked:Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .background(boxChecked ? .blue : .white)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
//                    boxChecked.toggle()
                }
 
            configuration.label
        }
    }
}
