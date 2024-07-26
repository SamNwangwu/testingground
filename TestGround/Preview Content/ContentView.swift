import SwiftUI

struct ContentView: View {
    @State private var selectedOption: MenuBarOptions = .food
    @State private var currentOption: MenuBarOptions = .food
    @State private var currentSubMenuOption: SubMenuOptions = .lunchDinner

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
                
                Text("Hawksmoor - Wood Wharf")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                
            }
            .padding(.horizontal)
            .foregroundStyle(.black)
            
            MenuOptionsList(selectedOption: $selectedOption, currentOption: $currentOption)
                .padding([.top, .horizontal])
                .overlay(
                    Divider()
                        .padding(.horizontal, -16)
                    , alignment: .bottom
                )
            
            SubMenuOptionsList(selectedOption: $selectedOption, currentSubMenuOption: $currentSubMenuOption)
                .padding([.top, .horizontal])
                .overlay(
                    Divider()
                        .padding(.horizontal, -16)
                    , alignment: .bottom
                )

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(MenuBarOptions.allCases, id: \.self) { option in
                            MenuItemSection(option: option, currentOption: $currentOption, currentSubMenuOption: $currentSubMenuOption)
                                .modifier(MainMenuOffsetModifier(option: option, currentOption: $currentOption))
                        }
                    }
                    .onChange(of: selectedOption) { newOption in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newOption, anchor: .topTrailing)
                        }
                        currentOption = newOption
                        currentSubMenuOption = getDefaultSubMenuOption(for: newOption)
                    }
                    .padding(.horizontal)
                }
                .coordinateSpace(name: "scroll")
            }
        }
    }
    
    private func getDefaultSubMenuOption(for option: MenuBarOptions) -> SubMenuOptions {
        switch option {
        case .food:
            return .lunchDinner
        case .cocktails:
            return .sacredSix
        case .wine:
            return .champagneAndFizz
        }
    }
}

#Preview {
    ContentView()
}
