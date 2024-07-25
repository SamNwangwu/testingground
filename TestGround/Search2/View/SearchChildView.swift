import SwiftUI
import NavigationTransitions

struct SearchChildView: View {
    @State private var searchText = ""
    @State private var recentSearches: [String] = ["Pizza", "Burgers", "Pasta"] // Example recent searches
    @State private var isSearchSubmitted: Bool = false // Track if a search has been submitted
    @State private var selectedFilter: String = "All" // Default selected filter
    @FocusState private var isSearchBarFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    let filters = ["All", "Top", "Nearby", "Users", "Venues"] // Filter options
    
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                VStack {
                    HStack {
                        ZStack {
                            CustomSearchBar(text: $searchText, textPadding: -4, onCommit: {
                                isSearchSubmitted = true
                                recentSearches.removeAll()
                                selectedFilter = "All" // Highlight "All" by default
                                // Handle the search action here
                            }) // Adjust text padding for SearchChildView
                            .padding(.horizontal, 14)
                            .padding(.top, 10)
                            .padding(.bottom, 4)
                            .padding(.leading, 5)
                            .padding(.trailing, -10)
                            .frame(width: 310)
                            .focused($isSearchBarFocused) // Set focus state here
                        }

                        NavigationLink(destination: SearchMainView().navigationBarBackButtonHidden(true)) {
                            Text("Cancel")
                                .frame(width: 55, height: 30)
                                .padding(.trailing, 70)
                                .padding(.leading, -1)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    // Show filter bar only after search is submitted
                    if isSearchSubmitted {
                        VStack(spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(filters, id: \.self) { filter in
                                        Text(filter)
                                            .fontWeight(.semibold)
                                            .foregroundColor(selectedFilter == filter ? .white : .gray)
                                            .underline(selectedFilter == filter, color: .black)
                                            .onTapGesture {
                                                selectedFilter = filter
                                                // Handle filter action here
                                            }
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .padding(.top, -1)
                            }
                        }
                    }

                    // Recent Searches List
                    if !isSearchSubmitted && !recentSearches.isEmpty {
                        VStack(spacing: 5) { // Reduced spacing between items
                            ForEach(recentSearches, id: \.self) { search in
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.white)
                                        .padding(.leading, -20)
                                    Text(search)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Button(action: {
                                        if let index = recentSearches.firstIndex(of: search) {
                                            recentSearches.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 34)
                                    }
                                }
                                .padding(.vertical, 4)
                                .background(Color.black) // Ensure background color if needed
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal, 14)
                    } else if !isSearchSubmitted {
                        // Display placeholder when no recent searches and search is not submitted
                        VStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.gray)
                            Text("Search Eatout")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Find your favorite dishes & drinks.")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                                .frame(height: 370)
                        }
                        .padding(.leading, -45)
                    }

                    Spacer()
                }
                .background(Color(.black))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        isSearchBarFocused = true
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationTransition(
            .fade(.in).animation(.easeInOut(duration: 0.01)))
    }
}

struct SearchChildView_Previews: PreviewProvider {
    static var previews: some View {
        SearchChildView()
    }
}
