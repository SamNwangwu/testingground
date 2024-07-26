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
}

enum SubMenuOptions: String, CaseIterable {
    // Food submenus
        case lunchDinner = "Lunch & Dinner"
        case lunchSpecials = "Lunch Specials"
        case puddings = "Puddings"
        case courses = "2/3 Courses £29/£33"
        case sundayRoast = "Sunday Roast"
        case sharingMenu = "Sharing Menu"
        
        // Cocktails submenus
        case sacredSix = "The Sacred Six"
        case ultimateSteakhouseCocktails = "Ultimate Steakhouse Cocktails"
        case timeAndPlace = "Time & A Place"
        case loAndNoAlc = "Lo & No Alc"
        case beersAndCider = "Beers & Cider"
        
        // Wine submenus
        case champagneAndFizz = "Champagne & Fizz"
        case whiteWines = "White Wines"
        case reserveWhites = "Reserve Whites"
        case redWines = "Red Wines"
        case fineReds = "Fine Reds"
        case reserveReds = "Reserve Reds"
        case roseAndOrange = "Rosé & Orange"
        case magnums = "Magnums"
        case portAndSherry = "Port & Sherry"
        case dessertWines = "Dessert Wines"
        
        var title: String {
            return self.rawValue
        }
        
        func belongsTo(option: MenuBarOptions) -> Bool {
            switch option {
            case .food:
                return [.lunchDinner, .lunchSpecials, .puddings, .courses, .sundayRoast, .sharingMenu].contains(self)
            case .cocktails:
                return [.sacredSix, .ultimateSteakhouseCocktails, .timeAndPlace, .loAndNoAlc, .beersAndCider].contains(self)
            case .wine:
                return [.champagneAndFizz, .whiteWines, .reserveWhites, .redWines, .fineReds, .reserveReds, .roseAndOrange, .magnums, .portAndSherry, .dessertWines].contains(self)
            }
        }
        
        static func subMenu(for option: MenuBarOptions) -> [SubMenuOptions] {
            switch option {
            case .food:
                return [.lunchDinner, .lunchSpecials, .puddings, .courses, .sundayRoast, .sharingMenu]
            case .cocktails:
                return [.sacredSix, .ultimateSteakhouseCocktails, .timeAndPlace, .loAndNoAlc, .beersAndCider]
            case .wine:
                return [.champagneAndFizz, .whiteWines, .reserveWhites, .redWines, .fineReds, .reserveReds, .roseAndOrange, .magnums, .portAndSherry, .dessertWines]
            }
        }
    }

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
}

struct SubMenu: Identifiable {
    let id = UUID()
    let title: SubMenuOptions
    let items: [MenuItem]
}

struct MenuData {
    // Food items
    static let lunchDinnerItems: [MenuItem] = [
        MenuItem(name: "Natural", description: "(x6/x12)", price: "21.00/42.00"),
        MenuItem(name: "Roasted with bone marrow", description: "(x3/x6)", price: "11.50/23.00"),
        MenuItem(name: "Scotch bonnet mignonette", description: "(x3/x6)", price: "10.75/21.50")
    ]
    
    static let startersItems: [MenuItem] = [
        MenuItem(name: "Roasted scallops", description: "white port, garlic butter", price: "21.00"),
        MenuItem(name: "Hawksmoor smoked salmon", description: "Guinness bread", price: "15.00"),
        MenuItem(name: "Devon crab on toast", description: "cucumber salad", price: "18.00"),
        // Add more items here
    ]
    
    static let mainsItems: [MenuItem] = [
        MenuItem(name: "Whole native lobster", description: "garlic butter", price: "9.20/100g"),
        MenuItem(name: "Roasted herb-fed chicken", description: "Béarnaise", price: "20.00"),
        // Add more items here
    ]
    
    static let lunchDinner = SubMenu(title: .lunchDinner, items: lunchDinnerItems)
    static let starters = SubMenu(title: .lunchSpecials, items: startersItems)
    static let mains = SubMenu(title: .puddings, items: mainsItems)
    
    static let foodSubMenus: [SubMenu] = [lunchDinner, starters, mains]
    
    // Cocktails items
    static let sacredSixItems: [MenuItem] = [
        MenuItem(name: "SHAKY PETE’S GINGER BREW", description: "Beefeater gin, Lemon juice, Ginger, London pride", price: "13.75"),
        MenuItem(name: "DOUBLE MELON DAIQUIRI", description: "Havana Club 3 y.o, Cantaloupe, Sour Watermelon, Rose Wine", price: "13.75"),
        MenuItem(name: "SOUR CHERRY NEGRONI", description: "East London Gin, Select Aperitivo, Regal Rogue Vermouth, Sour Cherry", price: "14.00"),
        // Add more items here
    ]
    
    static let ultimateSteakhouseCocktailsItems: [MenuItem] = [
        // Add items here
    ]
    
    static let timeAndPlaceItems: [MenuItem] = [
        // Add items here
    ]
    
    static let loAndNoAlcItems: [MenuItem] = [
        // Add items here
    ]
    
    static let beersAndCiderItems: [MenuItem] = [
        // Add items here
    ]
    
    static let sacredSix = SubMenu(title: .sacredSix, items: sacredSixItems)
    static let ultimateSteakhouseCocktails = SubMenu(title: .ultimateSteakhouseCocktails, items: ultimateSteakhouseCocktailsItems)
    static let timeAndPlace = SubMenu(title: .timeAndPlace, items: timeAndPlaceItems)
    static let loAndNoAlc = SubMenu(title: .loAndNoAlc, items: loAndNoAlcItems)
    static let beersAndCider = SubMenu(title: .beersAndCider, items: beersAndCiderItems)
    
    static let cocktailsSubMenus: [SubMenu] = [sacredSix, ultimateSteakhouseCocktails, timeAndPlace, loAndNoAlc, beersAndCider]
    
    // Wine items
    static let champagneAndFizzItems: [MenuItem] = [
        MenuItem(name: "Nino Franco, 'Rustico' Prosecco", description: "Italy, Veneto", price: "9.50"),
        // Add more items here
    ]
    
    static let whiteWinesItems: [MenuItem] = [
        // Add items here
    ]
    
    static let reserveWhitesItems: [MenuItem] = [
        // Add items here
    ]
    
    static let redWinesItems: [MenuItem] = [
        // Add items here
    ]
    
    static let fineRedsItems: [MenuItem] = [
        // Add items here
    ]
    
    static let reserveRedsItems: [MenuItem] = [
        // Add items here
    ]
    
    static let roseAndOrangeItems: [MenuItem] = [
        // Add items here
    ]
    
    static let magnumsItems: [MenuItem] = [
        // Add items here
    ]
    
    static let portAndSherryItems: [MenuItem] = [
        // Add items here
    ]
    
    static let dessertWinesItems: [MenuItem] = [
        // Add items here
    ]
    
    static let champagneAndFizz = SubMenu(title: .champagneAndFizz, items: champagneAndFizzItems)
    static let whiteWines = SubMenu(title: .whiteWines, items: whiteWinesItems)
    static let reserveWhites = SubMenu(title: .reserveWhites, items: reserveWhitesItems)
    static let redWines = SubMenu(title: .redWines, items: redWinesItems)
    static let fineReds = SubMenu(title: .fineReds, items: fineRedsItems)
    static let reserveReds = SubMenu(title: .reserveReds, items: reserveRedsItems)
    static let roseAndOrange = SubMenu(title: .roseAndOrange, items: roseAndOrangeItems)
    static let magnums = SubMenu(title: .magnums, items: magnumsItems)
    static let portAndSherry = SubMenu(title: .portAndSherry, items: portAndSherryItems)
    static let dessertWines = SubMenu(title: .dessertWines, items: dessertWinesItems)
    
    static let wineSubMenus: [SubMenu] = [champagneAndFizz, whiteWines, reserveWhites, redWines, fineReds, reserveReds, roseAndOrange, magnums, portAndSherry, dessertWines]
}
