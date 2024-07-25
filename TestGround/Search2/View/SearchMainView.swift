import SwiftUI
import NavigationTransitions

struct SearchMainView: View {
    @State private var searchText = ""
    @State private var showSearchChildView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    NavigationLink(destination: SearchChildView().navigationBarBackButtonHidden(true)) {
                        CustomSearchBar(text: $searchText, textPadding: -170) // Adjust text padding for SearchMainView
                            .padding(.horizontal, 20)
                            .padding(.leading, 45)
                            .padding(.top, 10)
                            .padding(.bottom, 4)
                            .frame(width: 390)
                    }
                    NavigationLink(destination: MapViewContainer().edgesIgnoringSafeArea(.all).navigationBarBackButtonHidden(true)) {
                        Image(systemName: "mappin.and.ellipse.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 60)
                            .padding(.top, 7)
                            .padding(.leading, -11)
                            .foregroundStyle(.white)
                    }
                }

                QuickSearchTabs()
                    .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 9) {
                        HorizontalPlaceholderView(title: "Recommended for you")
                        HorizontalPlaceholderView(title: "Spotlight")
                        HorizontalPlaceholderView(title: "Promotions Near You")
                    }
                    .padding(.top, 13)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
        }
        .navigationTransition(
            .fade(.in).animation(.easeInOut(duration: 0.01)))
    }
}

struct SearchMainView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMainView()
    }
}

