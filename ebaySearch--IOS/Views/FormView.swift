//
//  FormView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/3/23.
//

import SwiftUI
import CoreLocation

struct FormView: View {
    @StateObject var formInputs:FormInputs = FormInputs()
    @State var showResultView:Bool = false
    @StateObject var items:Items = Items()
    @State private var showAutoCompletionView:Bool = false
    
    @State private var isLoading: Bool = false
    
    @State var showToast: Bool = false
    @State var toasText:String = ""
    
    let categories = Categories.all
    var body: some View {
        Form {
            Section{
                // Keyword
                HStack {
                    Text("Keyword: ")
                    TextField("Required", text: $formInputs.keyword)
                }
                // Category
                Picker("Category: ", selection: $formInputs.category) {
                    ForEach(categories) { category in
                        Text(category.name).tag(category.name)
                    }
                }.padding([.bottom, .top], 7)
                // Condition
                VStack {
                    Text("Condition: ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Toggle(isOn: $formInputs.isUsed) {
                            Text("Used")
                        }.toggleStyle(CheckboxToggleStyle(boxChecked: $formInputs.isUsed))
                        Spacer()
                        Toggle(isOn: $formInputs.isNew) {
                            Text("New")
                        }.toggleStyle(CheckboxToggleStyle(boxChecked: $formInputs.isNew))
                        Spacer()
                        Toggle(isOn: $formInputs.isUnspecified) {
                            Text("Unspecified")
                        }.toggleStyle(CheckboxToggleStyle(boxChecked: $formInputs.isUnspecified))
                    }
                }
                // Shipping
                VStack {
                    Text("Shipping: ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Toggle(isOn: $formInputs.isPickup) {
                            Text("Pickup")
                        }.toggleStyle(CheckboxToggleStyle(boxChecked: $formInputs.isPickup))
                        Spacer()
                        Toggle(isOn: $formInputs.isFreeShipping) {
                            Text("Free Shipping")
                        }.toggleStyle(CheckboxToggleStyle(boxChecked: $formInputs.isFreeShipping))
                    }
                }
                // Distance
                HStack {
                    Text("Distance: ")
                    TextField("10", text: $formInputs.distance)
                }
                // Location
                Toggle(isOn: $formInputs.isCustomLocation) {
                    Text("Custom Location")
                }
                // Custom Location
                if formInputs.isCustomLocation {
                    HStack {
                        Text("Zipcode: ")
                        TextField("Required", text: $formInputs.customeZipcode)
                            .onSubmit {
                                showAutoCompletionView.toggle()
                            }
                            .sheet(isPresented: $showAutoCompletionView) {
                                AutoCompletionView(zipcodePrefix: $formInputs.customeZipcode)
                            }
                    }
                }
                // Buttons
                HStack{
                    Spacer()
                    Button(action: {
                        Task {
                            if formInputs.keyword == "" {
                                withAnimation {
                                    self.toasText = "Key word is mandatory"
                                    self.showToast = true
                                }
                            }
                            else if formInputs.isCustomLocation == true && formInputs.customeZipcode == "" {
                                withAnimation {
                                    self.toasText = "zipcode is mandatory"
                                    self.showToast = true
                                }
                            }
                            else if formInputs.isCustomLocation == true && formInputs.customeZipcode.count != 5 {
                                withAnimation {
                                    self.toasText = "Invalid zipcode"
                                    self.showToast = true
                                }
                            }
                            else {
                                self.isLoading = true
                                self.showResultView = true
                                await getItems()
                            }
                        }
                    }) {
                        Text("Submit")
                            .frame(width: 80, height: 22)
                            .font(.system(size: 18))
                            .padding()
                            .foregroundColor(.white)
                    }
                    .background(.blue)
                    .cornerRadius(10)
                    .buttonStyle(.borderless)
                    Spacer()
                    Button(action: {
                        resetForm()
                    }) {
                        Text("Clear")
                            .frame(width: 80, height: 22)
                            .font(.system(size: 18))
                            .padding()
                            .foregroundColor(.white)
                    }
                    .background(.blue)
                    .cornerRadius(10)
                    .buttonStyle(.borderless)
                    Spacer()
                }
            }
            Section {
                if showResultView == true {
                    ResultView(items:$items.items, showToast:$showToast, toasText: $toasText, isLoading: $isLoading, keyword: formInputs.keyword)
                }
            }
        }.task{
            await getCurrentZipcode(formInputs: formInputs)
        }
        .toast(isPresented: self.$showToast) {
            HStack {
                Text(toasText).foregroundStyle(.white)
            } //HStack
        } //toast
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    func getItems() async{
        let urlString = buildURLString(formInputs: formInputs)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedItems = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    self.items.items = decodedItems
                }
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                isLoading = false
            }
        }.resume()
    }
    
    private func buildURLString(formInputs: FormInputs) -> String {
        var urlString = Constants.Urls.fetchItems
        urlString += "keywords=\(formInputs.keyword)&"
        if formInputs.isCustomLocation && !formInputs.customeZipcode.isEmpty {
            urlString += "postalCode=\(formInputs.customeZipcode)&"
        }
        else {
            urlString += "postalCode=\(formInputs.currentZipcode)&"
        }
        
        var categoryId: String = ""
        
        switch formInputs.category {
        case "All":
            categoryId = ""
        case "Art":
            categoryId = "550"
        case "Baby":
            categoryId = "2984"
        case "Books":
            categoryId = "267"
        case "Clothing, Shoes & Accessories":
            categoryId = "11450"
        case "Computers/Tablets & Networking":
            categoryId = "58058"
        case "Health & Beauty":
            categoryId = "26395"
        case "Music":
            categoryId = "11233"
        case "Video Games & Consoles":
            categoryId = "1249"
        default:
            categoryId = ""
        }
        
        if formInputs.category != "" {
            urlString += "categoryId=\(categoryId)&"
        }
        
        
        // Conditions
        let conditions: [String] = [
            formInputs.isNew ? "New" : nil,
            formInputs.isUsed ? "Used" : nil,
            formInputs.isUnspecified ? "Unspecified" : nil
        ].compactMap { $0 }
        
        if !conditions.isEmpty {
            urlString += "conditions=\(conditions.joined(separator: ","))&"
        }
        
        // Shipping Options
        let shippingOptions: [String] = [
            formInputs.isPickup ? "LocalPickupOnly" : nil,
            formInputs.isFreeShipping ? "FreeShippingOnly" : nil
        ].compactMap { $0 }
        
        if !shippingOptions.isEmpty {
            urlString += "shippingOptions=\(shippingOptions.joined(separator: ","))&"
        }
        
        // Distance
        if !formInputs.distance.isEmpty {
            urlString += "maxDistance=\(formInputs.distance)&"
        } else {
            urlString += "maxDistance=10&"
        }
        
        urlString += "numEntries=50&page=1"
        
        return urlString
    }
    
    
    func resetForm() {
        formInputs.keyword = ""
        formInputs.category = ""
        formInputs.isUsed = false
        formInputs.isNew = false
        formInputs.isUnspecified = false
        formInputs.isPickup = false
        formInputs.isFreeShipping = false
        formInputs.distance = ""
        formInputs.isCustomLocation = false
        formInputs.customeZipcode = ""
        showResultView = false
    }
}


#if DEBUG
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
#endif
