//
//  PlacesSearchView.swift
//  TestGround
//
//  Created by User on 20/07/2024.
//

import SwiftUI
import GooglePlaces

struct PlaceSearchView: View {
    @StateObject private var locationService = LocationService()
    @State private var search: String = ""
    @State private var selectedPlace: SearchCompletions?
    @State private var showingReviewRating = false
    @State private var isExpanded = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("Search for a place to review", text: $search)
                            .autocorrectionDisabled()
                            .onChange(of: search) { newValue in
                                locationService.update(queryFragment: newValue)
                            }
                        
                        if search.isEmpty {
                            Button(action: {
                                // Handle microphone action
                                startVoiceSearch()
                            }) {
                                Image(systemName: "mic.fill")
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Button(action: {
                                search = ""
                                locationService.update(queryFragment: search)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .modifier(TextFieldGrayBackgroundColor())
                    .padding()
                    
                    Button(action: {
                        // Handle search action
                        startSearch()
                    }) {
                        Text("Search")
                            .foregroundColor(.black)
                    }
                    .padding(.leading, -10)
                    .padding(.bottom, 3)
                    .padding(.trailing, 6)

                    Spacer()
                }
                
                Spacer()
                
                if locationService.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(locationService.completions) { completion in
                            NavigationLink(
                                destination: ReviewRatingView(
                                    placeName: completion.title,
                                    placeLocation: completion.subTitle,
                                    isExpanded: $isExpanded
                                )
                            ) {
                                VStack(alignment: .leading, spacing: 4) {
                                    highlightText(completion.title, matching: search)
                                        .font(.headline)
                                        .fontDesign(.rounded)
                                        .foregroundColor(locationService.isLoading ? .gray : .primary)
                                    highlightText(completion.subTitle, matching: search)
                                        .foregroundColor(locationService.isLoading ? .gray : .secondary)
                                }
                            }
                            .disabled(locationService.isLoading)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .interactiveDismissDisabled()
        .environmentObject(locationService) // Provide the locationService as an environment object
    }
    
    private func startSearch() {
        // Implement your search functionality here
        print("Search initiated with text: \(search)")
    }
    
    private func startVoiceSearch() {
        // Implement your voice search functionality here
        print("Voice search initiated")
    }
    
    private func highlightText(_ text: String, matching search: String) -> Text {
        guard !search.isEmpty else {
            return Text(text)
        }
        
        let highlightColor = Color.pink // Change to the desired pink color
        let ranges = text.lowercased().ranges(of: search.lowercased())
        var result = Text("")
        var currentIndex = text.startIndex
        
        for range in ranges {
            let prefix = text[currentIndex..<range.lowerBound]
            let match = text[range]
            result = result + Text(prefix) + Text(match).foregroundColor(highlightColor)
            currentIndex = range.upperBound
        }
        
        result = result + Text(text[currentIndex..<text.endIndex])
        return result
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIndex = self.startIndex
        
        while startIndex < self.endIndex,
              let range = self[startIndex...]
                .range(of: searchString, options: .caseInsensitive) {
            ranges.append(range)
            startIndex = range.upperBound
        }
        
        return ranges
    }
}

struct PlaceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchView()
            .environmentObject(LocationService())
    }
}
