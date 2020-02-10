//
//  CountryList.swift
//  Countries
//
//  Created by Gerrit Jan te Velde on 09.02.20.
//  Copyright © 2020 Gerrit Jan te Velde. All rights reserved.
//

import Foundation
import Combine

enum APIError: Error {
    case network(description: String)
    case unknown
}

class CountryListViewModel: ObservableObject {
    
    @Published var countries = [CountryListRowViewModel]()
    
    private var rcCountries = [Country]() {
        didSet {
            rcCountries.forEach { (country) in
                self.countries.append(CountryListRowViewModel(country: country))
            }
        }
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    init() { }
    
    func fetchAll() {
        RCNetworker().fetchAll()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }) { (countries) in
                self.rcCountries = countries
            }
            .store(in: &cancellable)
    }
}
