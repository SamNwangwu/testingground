import Foundation

enum MenuBarOptions: Int, CaseIterable {
    case food
    case cocktails
    case wine
    
    var title: String {
        switch self {
        case .food: return "Food"
        case .cocktails: return "Cocktails"
        case .wine: return "Wine"
        }
    }
    
    var foodItems: [FoodItem] {
        switch self {
        case .food:
            return [
                FoodItem(title: "Natural Oysters", description: "Delicious natural oysters", price: "21.00/42.00 (x6/x12)", imageName: "oysters"),
                FoodItem(title: "Roasted scallops", description: "White port, garlic butter", price: "21.00", imageName: "scallops"),
                FoodItem(title: "Hawksmoor smoked salmon", description: "Guinness bread", price: "15.00", imageName: "smoked_salmon"),
                FoodItem(title: "Devon crab on toast", description: "Cucumber salad", price: "18.00", imageName: "crab_toast"),
                FoodItem(title: "Potted beef & bacon", description: "Yorkshires & onion gravy", price: "11.00", imageName: "potted_beef"),
                FoodItem(title: "Fillet carpaccio", description: "Pickled chestnut mushrooms, parmesan", price: "15.00", imageName: "carpaccio"),
                FoodItem(title: "Bone marrow & onions", description: "Sourdough toast", price: "11.00", imageName: "bone_marrow"),
                FoodItem(title: "Old Spot belly ribs", description: "Vinegar slaw", price: "15.00", imageName: "belly_ribs"),
                FoodItem(title: "Bitter leaf salad", description: "Devon blue & candied pecans", price: "11.50", imageName: "bitter_leaf_salad"),
                FoodItem(title: "Summer salad", description: "Peas, sugar snaps, cashew ricotta", price: "10.50/18.50", imageName: "summer_salad")
            ]
        case .cocktails:
            return [
                FoodItem(title: "The Sacred Six", description: "Ultimate Steakhouse Cocktails", price: "12.50", imageName: "cocktail1"),
                FoodItem(title: "Ultimate Steakhouse Cocktails", description: "Classic cocktails", price: "12.00", imageName: "cocktail2"),
                FoodItem(title: "Time & A Place", description: "Unique blends", price: "13.00", imageName: "cocktail3"),
                FoodItem(title: "Martini", description: "Gin, vermouth, olive", price: "10.00", imageName: "martini"),
                FoodItem(title: "Margarita", description: "Tequila, lime, salt", price: "11.00", imageName: "margarita"),
                FoodItem(title: "Old Fashioned", description: "Whiskey, bitters, sugar", price: "12.00", imageName: "old_fashioned"),
                FoodItem(title: "Negroni", description: "Gin, vermouth, Campari", price: "12.50", imageName: "negroni"),
                FoodItem(title: "Mojito", description: "Rum, mint, lime, soda", price: "10.50", imageName: "mojito"),
                FoodItem(title: "Daiquiri", description: "Rum, lime, sugar", price: "10.00", imageName: "daiquiri")
            ]
        case .wine:
            return [
                FoodItem(title: "Red Wine", description: "A selection of red wines", price: "30.00", imageName: "red_wine"),
                FoodItem(title: "White Wine", description: "A selection of white wines", price: "28.00", imageName: "white_wine"),
                FoodItem(title: "Rosé", description: "A selection of rosé wines", price: "25.00", imageName: "rose_wine"),
                FoodItem(title: "Chardonnay", description: "A rich white wine", price: "32.00", imageName: "chardonnay"),
                FoodItem(title: "Cabernet Sauvignon", description: "A full-bodied red wine", price: "35.00", imageName: "cabernet_sauvignon"),
                FoodItem(title: "Merlot", description: "A soft red wine", price: "28.00", imageName: "merlot"),
                FoodItem(title: "Pinot Grigio", description: "A light white wine", price: "26.00", imageName: "pinot_grigio"),
                FoodItem(title: "Sauvignon Blanc", description: "A crisp white wine", price: "30.00", imageName: "sauvignon_blanc")
            ]
        }
    }
}

struct SubSubMenu {
    let title: String
    let items: [FoodItem]
}

struct SubMenu {
    let title: String
    let subSubMenus: [SubSubMenu]
}

struct MainMenu {
    let option: MenuBarOptions
    let subMenus: [SubMenu]
}

struct MenuData {
    static let menus: [MainMenu] = [
        MainMenu(
            option: .food,
            subMenus: [
                SubMenu(
                    title: "Lunch & Dinner",
                    subSubMenus: [
                        SubSubMenu(
                            title: "Oysters",
                            items: [
                                FoodItem(title: "Natural", description: "", price: "21.00/42.00 (x6/x12)", imageName: ""),
                                FoodItem(title: "Roasted with bone marrow", description: "", price: "11.50/23.00 (x3/x6)", imageName: ""),
                                FoodItem(title: "Scotch bonnet mignonette", description: "", price: "10.75/21.50 (x3/x6)", imageName: ""),
                                FoodItem(title: "Lemon and herb", description: "Fresh lemon and herbs", price: "15.00", imageName: ""),
                                FoodItem(title: "Garlic butter", description: "Rich garlic butter sauce", price: "16.00", imageName: ""),
                                FoodItem(title: "Chili lime", description: "Spicy chili lime dressing", price: "17.00", imageName: "")
                            ]
                        ),
                        SubSubMenu(
                            title: "Starters",
                            items: [
                                FoodItem(title: "Roasted scallops", description: "white port, garlic butter", price: "21.00", imageName: ""),
                                FoodItem(title: "Hawksmoor smoked salmon", description: "Guinness bread", price: "15.00", imageName: ""),
                                FoodItem(title: "Devon crab on toast", description: "cucumber salad", price: "18.00", imageName: ""),
                                FoodItem(title: "Potted beef & bacon", description: "Yorkshires & onion gravy", price: "11.00", imageName: ""),
                                FoodItem(title: "Fillet carpaccio", description: "pickled chestnut mushrooms, parmesan", price: "15.00", imageName: ""),
                                FoodItem(title: "Bone marrow & onions", description: "sourdough toast", price: "11.00", imageName: ""),
                                FoodItem(title: "Old Spot belly ribs", description: "vinegar slaw", price: "15.00", imageName: ""),
                                FoodItem(title: "Bitter leaf salad", description: "Devon blue & candied pecans", price: "11.50", imageName: ""),
                                FoodItem(title: "Summer salad", description: "peas, sugar snaps, cashew ricotta", price: "10.50/18.50", imageName: "")
                            ]
                        ),
                        // Add more sub-sub-menus here...
                    ]
                ),
                // Add more sub-menus here...
            ]
        ),
        // Add more main menus here...
    ]
}
