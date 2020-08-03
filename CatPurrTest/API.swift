//
//  API.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 8/2/20.
//

import Foundation
import SwiftUI

struct Response: Codable {
    var results: [String]
}

func loadAPIData(cats: Cats) {
    var catNames: [String] = []
    
    guard let url = URL(string: "https://purr-api.joyrats.com/api/cats") else {
    print("Invalid URL")
    return
    }
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "Get"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            // convert data to string to array
            let catNamesArrayString = String(decoding: data, as: UTF8.self)
            catNames = catNamesArrayString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of:
            "]", with: "").components(separatedBy: ",")
            
            // update data model
            DispatchQueue.main.async {
                cats.collection = catNames
            }
            return
        }
        
        // if we're still here ... something went wrong
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        return
    }.resume()
}
