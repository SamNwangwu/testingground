import SwiftUI
import Photos

struct TagItemView: View {
    @Binding var selectedAssets: [PHAsset]
    @State private var showTagSheet = false
    @State private var currentAsset: PHAsset? {
        didSet {
            if let currentAsset = currentAsset {
                assetTags = tags[currentAsset.localIdentifier] ?? []
            }
        }
    }
    @State private var tags: [String: [String]] = [:]  // Dictionary to store tags for each media item
    @State private var assetTags: [String] = [] // Tags for the current asset

    var body: some View {
        VStack {
            mediaCarousel
            tagsView
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            if let firstAsset = selectedAssets.first {
                currentAsset = firstAsset
            }
        }
        .onChange(of: currentAsset) { newAsset in
            if let currentAsset = newAsset {
                assetTags = tags[currentAsset.localIdentifier] ?? []
                print("currentAsset changed: \(currentAsset.localIdentifier)")
                print("assetTags: \(assetTags)")
            }
        }
        .sheet(isPresented: $showTagSheet) {
            TagSheetView(selectedAsset: $currentAsset, tags: $tags, showTagSheet: $showTagSheet, assetTags: $assetTags)
        }
    }

    private var mediaCarousel: some View {
        VStack {
            TabView(selection: $currentAsset) {
                ForEach(selectedAssets, id: \.self) { asset in
                    AssetImageView(asset: asset, isSelected: currentAsset == asset, isMultiSelectMode: false, selectionNumber: nil)
                        .tag(asset)
                        .onAppear {
                            currentAsset = asset
                            print("Asset in view (onAppear): \(asset.localIdentifier)")
                        }
                        .onTapGesture {
                            handleAssetTap(asset)
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: UIScreen.main.bounds.height * 0.4) // Fixed height for carousel
        }
    }
    
    private func handleAssetTap(_ asset: PHAsset) {
        currentAsset = asset
        showTagSheet = true
    }

    private var tagsView: some View {
        ScrollView {
            if !assetTags.isEmpty {
                ItemView(assetTags: assetTags, removeTag: { tag in
                    removeTag(tag, from: currentAsset!)
                })
                .transition(.opacity)
            } else {
                InstructionsView()
                    .transition(.opacity)
            }
        }
        .background(Color.black)
        .padding(.top, 8)
        .padding(.horizontal, 15)
    }

    private func removeTag(_ tag: String, from asset: PHAsset) {
        guard var assetTags = tags[asset.localIdentifier] else { return }
        assetTags.removeAll { $0 == tag }
        tags[asset.localIdentifier] = assetTags
        if currentAsset?.localIdentifier == asset.localIdentifier {
            self.assetTags = assetTags
        }
    }
}

struct InstructionsView: View {
    var body: some View {
        VStack {
            Text("Tap media to tag food or drink.")
                .font(.headline)
                .foregroundColor(.white)
            Text("Swipe to see more.")
                .font(.headline)
                .foregroundColor(.white)
        }
        .background(Color.clear)
    }
}

struct ItemView: View {
    let assetTags: [String]
    let removeTag: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(assetTags, id: \.self) { tag in
                HStack {
                    Image(systemName: "photo") // Placeholder for official image
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(5)
                        .padding(.trailing, 8)
                    Text(tag)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .onTapGesture {
                            removeTag(tag)
                        }
                }
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .background(Color.clear)
    }
}

struct TagSheetView: View {
    @Binding var selectedAsset: PHAsset?
    @Binding var tags: [String: [String]]
    @Binding var showTagSheet: Bool
    @Binding var assetTags: [String]

    @State private var selectedItems: [String] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(foodItems, id: \.self) { item in
                    MultipleSelectionRow(item: item, isSelected: selectedItems.contains(item)) {
                        if selectedItems.contains(item) {
                            selectedItems.removeAll { $0 == item }
                        } else {
                            selectedItems.append(item)
                        }
                    }
                }
            }
            .navigationTitle("Select Items")
            .navigationBarItems(trailing: Button("Done") {
                if let asset = selectedAsset {
                    tags[asset.localIdentifier] = selectedItems
                    assetTags = selectedItems
                    showTagSheet = false
                }
            })
        }
    }

    private let foodItems = [
        "Burger", "Pizza", "Pasta", "Salad", "Sushi",
        "Steak", "Tacos", "Ice Cream", "Fries", "Soup"
    ]
}

struct MultipleSelectionRow: View {
    var item: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Text(item)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { action() }
    }
}


#if DEBUG
struct TagItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TagItemView(selectedAssets: .constant([PHAsset(), PHAsset()]))
        }
    }
}
#endif
