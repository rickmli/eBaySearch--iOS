//
//  autoCompletionView.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/5/23.
//

import SwiftUI

struct AutoCompletionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var zipcodePrefix: String
    @State var options:[String] = []
    @State private var isLoading: Bool = false
    @State private var hasTimeElapsed = false
    
    var body: some View {
        VStack{
            if isLoading  {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()).id(UUID())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                Spacer()
            } else {
                Text("Pincode Suggestions")
                    .fontWeight(.heavy)
                    .font(.system(size: 30))
                    .background(.white)
                    .padding(20)
                List{
                    if options.count == 0 {
                        Text("No results found.")
                            .foregroundStyle(.red)
                    }
                    else {
                        ForEach(options, id: \.self) {option in
                            Button(action: {
                                Task {
                                    zipcodePrefix = option
                                    dismiss()
                                }
                            }) {
                                Text(option)
                            }.foregroundColor(.black)
                        }
                    }
                }
            }
        }.task {
            await getOptions()
        }
    }
    
    private func delay() async{
        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 900_000_000)
        hasTimeElapsed = true
    }
    
    func getOptions() async {
        isLoading = true
        guard let url = URL(string: "\(Constants.Urls.fetchOptions)prefix=\(zipcodePrefix)&maxRow=5") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedOptions = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    self.options = decodedOptions
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
//    autoCompletionView()
//}
