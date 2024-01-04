//
//  File.swift
//  ebaySearch--IOS
//
//  Created by Rick Li on 12/4/23.
//

import Foundation

func getCurrentZipcode(formInputs: FormInputs) async {
    
    guard let url = URL(string: Constants.Urls.fetchCurrentPosition) else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else { return }
        do {
            let currentPosition = try JSONDecoder().decode(CurrentPosition.self, from: data)
            DispatchQueue.main.async {
                formInputs.currentZipcode = currentPosition.postal
            }
        } catch {
            print(error.localizedDescription)
        }
    }.resume()
}
