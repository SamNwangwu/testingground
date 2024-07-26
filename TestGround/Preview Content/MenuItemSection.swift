import SwiftUI

struct MenuItemSection: View {
    let option: MenuBarOptions
    @Binding var currentOption: MenuBarOptions
    @Binding var currentSubMenuOption: SubMenuOptions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(option.title)
                .font(.title.bold())
                .padding(.vertical)
            
            ForEach(getSubMenus(for: option)) { subMenu in
                VStack(alignment: .leading, spacing: 8) {
                    Text(subMenu.title.rawValue)
                        .font(.title2.bold())
                        .padding(.vertical)
                        .modifier(SubMenuOffsetModifier(option: subMenu.title, currentOption: $currentSubMenuOption))
                    
                    ForEach(subMenu.items, id: \.name) { item in
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.name)
                                    .font(.title3.bold())
                                
                                Text(item.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("Price: \(item.price)")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            Image(item.name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 88)
                                .clipped()
                                .cornerRadius(10)
                        }
                        
                        Divider()
                    }
                }
            }
        }
        .modifier(MainMenuOffsetModifier(option: option, currentOption: $currentOption))
    }
    
    private func getSubMenus(for option: MenuBarOptions) -> [SubMenu] {
        switch option {
        case .food:
            return MenuData.foodSubMenus
        case .cocktails:
            return MenuData.cocktailsSubMenus
        case .wine:
            return MenuData.wineSubMenus
        }
    }
}
