//
//  DescriptionsView.swift
//  eBaySearch
//
//  Created by Rick Li on 11/25/23.
//

import SwiftUI

struct DescriptionsView: View {
    var descriptions: [Description] = []
    
    var body: some View {
        Divider()
        ForEach(descriptions, id: \.name) { description in
            HStack{
                Text(description.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description.value)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Divider()
        }
    }
    
}

#Preview {
    
    DescriptionsView(descriptions: [])
}
