import SwiftUI

struct SubMenuOptionsList: View {
    @Binding var selectedOption: MenuBarOptions
    @Binding var currentSubMenuOption: SubMenuOptions
    @Namespace var animation

    var body: some View {
        let filteredSubMenuOptions = SubMenuOptions.allCases.filter { $0.belongsTo(option: selectedOption) }
        
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(filteredSubMenuOptions, id: \.self) { item in
                        VStack {
                            Text(item.title)
                                .foregroundColor(item == currentSubMenuOption ? .black : .gray)
                                .fontWeight(item == currentSubMenuOption ? .semibold : .regular)
                            
                            if currentSubMenuOption == item {
                                Capsule()
                                    .fill(.black)
                                    .matchedGeometryEffect(id: "subItem", in: animation)
                                    .frame(height: 3)
                                    .padding(.horizontal, -10)
                            } else {
                                Capsule()
                                    .fill(.clear)
                                    .frame(height: 3)
                                    .padding(.horizontal, -10)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                print("SubMenu Option Tapped: \(item)")
                                self.currentSubMenuOption = item
                                print("Current SubMenu Option Changed: \(currentSubMenuOption)")
                                proxy.scrollTo(item, anchor: .topTrailing)
                                print("Scrolling to SubMenuOption: \(item)")
                            }
                        }
                    }
                }
                .onChange(of: currentSubMenuOption) { newValue in
                    proxy.scrollTo(newValue, anchor: .topTrailing)
                    print("Current SubMenu Option Changed: \(newValue)")
                    print("Scrolling to SubMenuOption: \(newValue)")
                }
            }
        }
    }
}

//#Preview {
//    SubMenuOptionsList(selectedOption: .constant(.food), currentSubMenuOption: .constant(.lunchDinner))
//}
