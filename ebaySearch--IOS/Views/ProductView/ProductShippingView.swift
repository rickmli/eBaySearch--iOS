//
//  ProductShippingView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI

struct ProductShippingView: View {
    let itemDetails: ItemDetails
    
    var body: some View {
        VStack {
            if itemDetails.storeName != "" || itemDetails.feedbackScore != "" || itemDetails.popularity != ""  {
                Divider()
                HStack{
                    Image(systemName: "storefront")
                    Text("Seller")
                }.frame(maxWidth: .infinity,alignment: .leading)
                Divider()
            }
            VStack{
                if itemDetails.storeName != "" {
                    HStack{
                        Text("Store Name")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(.init("[\(itemDetails.storeName)](\(itemDetails.storeURL))"))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                if itemDetails.feedbackScore != "" {
                    HStack{
                        Text("Feedback Score")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.feedbackScore)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                if itemDetails.popularity != "" {
                    HStack{
                        Text("Popularity")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.popularity)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            if itemDetails.shippingCost != "" || itemDetails.isGlobalShipping != "" || itemDetails.handlingTime != ""  {
                Divider()
                HStack{
                    Image(systemName: "sailboat")
                    Text("Shipping Info")
                }.frame(maxWidth: .infinity,alignment: .leading)
                Divider()
            }
            VStack{
                if itemDetails.shippingCost != "" {
                    HStack{
                        Text("Shipping Cost")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.shippingCost)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                if itemDetails.isGlobalShipping != "" {
                    HStack{
                        Text("Global Shipping")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.isGlobalShipping)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                if itemDetails.handlingTime != "" {
                    HStack{
                        Text("Handling Time")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(itemDetails.handlingTime) day")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            if itemDetails.policy != "" || itemDetails.refundMode != "" || itemDetails.returnsWithin != "" || itemDetails.shippingCostPaidBy != "" {
                Divider()
                HStack{
                    Image(systemName: "return")
                    Text("Return Policy")
                }.frame(maxWidth: .infinity,alignment: .leading)
                Divider()
            }
            VStack{
                if itemDetails.policy != "" {
                    HStack{
                        Text("Policy")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.policy)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                if itemDetails.refundMode != "" {
                    HStack{
                        Text("Refund Mode")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.refundMode)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                }
                if itemDetails.returnsWithin != "" {
                    HStack{
                        Text("Returns Within")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.returnsWithin)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                }
                if itemDetails.shippingCostPaidBy != "" {
                    HStack{
                        Text("Shipping Cost Paid By")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(itemDetails.shippingCostPaidBy)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
}

//#Preview {
//    ProductShippingView()
//}
