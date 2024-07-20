//
//  LocationService.swift
//  TestGround
//
//  Created by User on 20/07/2024.
//

import GooglePlaces
import SwiftUI

struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    let placeID: String
}

class LocationService: ObservableObject {
    @Published var completions = [SearchCompletions]()
    @Published var isLoading = false // Add loading state
    private var placesClient: GMSPlacesClient!

    init() {
        self.placesClient = GMSPlacesClient.shared()
    }

    func update(queryFragment: String) {
        isLoading = true // Start loading
        let filter = GMSAutocompleteFilter()
        filter.types = ["establishment"]
        filter.countries = ["UK"]

        let token = GMSAutocompleteSessionToken.init()
        placesClient.findAutocompletePredictions(fromQuery: queryFragment, filter: filter, sessionToken: token) { [weak self] (results, error) in
            if let error = error {
                print("Autocomplete error: \(error.localizedDescription)")
                self?.isLoading = false
                return
            }
            guard let results = results else {
                self?.completions = []
                self?.isLoading = false
                return
            }
            self?.filterAndFetchPlaces(predictions: results)
        }
    }

    private func filterAndFetchPlaces(predictions: [GMSAutocompletePrediction]) {
        var validCompletions = [SearchCompletions]()
        let group = DispatchGroup()

        for prediction in predictions {
            group.enter()
            placesClient.lookUpPlaceID(prediction.placeID) { (place, error) in
                defer { group.leave() }

                if let error = error {
                    print("Error looking up place ID: \(error.localizedDescription)")
                    return
                }

                guard let place = place, let types = place.types else { return }
                if types.contains("restaurant") || types.contains("cafe") || types.contains("bar") || types.contains("food") {
                    let completion = SearchCompletions(title: prediction.attributedPrimaryText.string, subTitle: prediction.attributedSecondaryText?.string ?? "", placeID: prediction.placeID)
                    validCompletions.append(completion)
                }
            }
        }

        group.notify(queue: .main) {
            self.completions = validCompletions
            self.isLoading = false // Stop loading
        }
    }
}
