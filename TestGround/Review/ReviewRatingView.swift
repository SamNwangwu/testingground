//
//  ReviewRatingView.swift
//  TestGround
//
//  Created by User on 20/07/2024.
//

import SwiftUI

struct ReviewRatingView: View {
    let placeName: String
    let placeLocation: String

    @State private var currentStep: Int = 0
    @State private var foodQualityRating: CGFloat = 0.0
    @State private var ambianceRating: CGFloat = 0.0
    @State private var serviceRating: CGFloat = 0.0
    @State private var valueRating: CGFloat = 0.0
    @Namespace private var animationNamespace
    @State private var showAverageRating = false
    @State private var showCameraView = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var isExpanded: Bool
    let starWidth: CGFloat = 20
    let initialStarWidth: CGFloat = 30 // Adjusted initial size to fit better

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                    if currentStep >= 4 {
                        NavigationLink(destination: CameraView(returnToReview: {
                            presentationMode.wrappedValue.dismiss()
                        })) {
                            Text("Next")
                                .padding()
                        }
                    }
                }

                VStack(spacing: 4) {
                    Text(placeName)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(placeLocation)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                ForEach(0..<currentStep, id: \.self) { step in
                    VStack(spacing: 8) { // Increased spacing between selected reviews
                        SelectedRatingHeader(title: headerTitle(for: step))
                            .matchedGeometryEffect(id: "header\(step)", in: animationNamespace)
                        if step == 3 {
                            PoundRatingView(
                                dragOffset: ratingBinding(for: step, isInitial: false),
                                starWidth: starWidth,
                                spacing: 3 // Reduced spacing for selected view
                            )
                                .matchedGeometryEffect(id: "ratingBar\(step)", in: animationNamespace)
                        } else {
                            StarRatingView(
                                dragOffset: ratingBinding(for: step, isInitial: false),
                                starWidth: starWidth,
                                spacing: 3 // Reduced spacing for selected view
                            )
                                .matchedGeometryEffect(id: "ratingBar\(step)", in: animationNamespace)
                        }
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 10)
                }
                .padding(.top, 30) // Increased top padding

                Spacer()

                if currentStep < 4 {
                    VStack(spacing: 20) {
                        RatingHeader(title: headerTitle(for: currentStep), subheadline: subheadline(for: currentStep))
                            .matchedGeometryEffect(id: "header\(currentStep)", in: animationNamespace)
                        if currentStep == 3 {
                            PoundRatingView(
                                dragOffset: ratingBinding(for: currentStep, isInitial: true),
                                starWidth: initialStarWidth,
                                spacing: 5, // Spacing for initial selection view
                                onEnded: handleDragEnd
                            )
                                .matchedGeometryEffect(id: "ratingBar\(currentStep)", in: animationNamespace)
                        } else {
                            StarRatingView(
                                dragOffset: ratingBinding(for: currentStep, isInitial: true),
                                starWidth: initialStarWidth,
                                spacing: 5, // Spacing for initial selection view
                                onEnded: handleDragEnd
                            )
                                .matchedGeometryEffect(id: "ratingBar\(currentStep)", in: animationNamespace)
                        }
                    }
                    .frame(height: 120)
                    .padding(.top, 20)
                }

                if showAverageRating {
                    VStack {
                        Text("OVERALL RATING")
                            .font(.system(size: 14)) // Set custom font size
                            .foregroundColor(.gray)
                            .padding(.bottom, 2)
                            .frame(maxWidth: .infinity, alignment: .center) // Center align the text
                        Text(String(format: "%.1f", min(averageRating, 10))) // Cap the average rating at 10
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .foregroundColor(ratingColor(averageRating: averageRating)) // Dynamically change color
                            .padding(.top, 10)
                            .transition(.scale)
                    }
                    .onAppear {
                        print("Average Rating: \(averageRating)")
                    }
                }

                Spacer()

                // Instruction for the next step
                if currentStep >= 4 {
                    Text("Next, add photos/videos to your review.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
            }
            .padding()
            .animation(.easeInOut, value: currentStep)
            .animation(.easeInOut, value: showAverageRating)
        }
        .sheet(isPresented: $showCameraView) {
            CameraView(returnToReview: {
                showCameraView = false
            })
        }
    }

    private func headerTitle(for step: Int) -> String {
        switch step {
        case 0: return "Food Quality"
        case 1: return "Ambiance"
        case 2: return "Service"
        case 3: return "Value"
        default: return ""
        }
    }

    private func subheadline(for step: Int) -> String {
        switch step {
        case 0: return "Did your meal meet expectations?"
        case 1: return "How was the atmosphere?"
        case 2: return "How was the service?"
        case 3: return "Was the experience worth the price?"
        default: return ""
        }
    }

    private func ratingBinding(for step: Int, isInitial: Bool) -> Binding<CGFloat> {
        Binding(
            get: {
                switch step {
                case 0: return isInitial ? foodQualityRating * (initialStarWidth * 10 / 10) : foodQualityRating * (starWidth * 10 / 10)
                case 1: return isInitial ? ambianceRating * (initialStarWidth * 10 / 10) : ambianceRating * (starWidth * 10 / 10)
                case 2: return isInitial ? serviceRating * (initialStarWidth * 10 / 10) : serviceRating * (starWidth * 10 / 10)
                case 3: return isInitial ? valueRating * (initialStarWidth * 10 / 10) : valueRating * (starWidth * 10 / 10)
                default: return foodQualityRating * (starWidth * 10 / 10)
                }
            },
            set: { newValue in
                let rating = newValue / (isInitial ? initialStarWidth * 10 : starWidth * 10)
                switch step {
                case 0: foodQualityRating = rating * 10
                case 1: ambianceRating = rating * 10
                case 2: serviceRating = rating * 10
                case 3: valueRating = rating * 10
                default: break
                }
            }
        )
    }

    private var averageRating: Double {
        let ratings = [min(foodQualityRating, 10), min(ambianceRating, 10), min(serviceRating, 10), min(valueRating, 10)]
        let total = ratings.reduce(0, +)
        return Double(total) / 4.0
    }

    private func handleDragEnd() {
        if currentStep < 3 {
            withAnimation(.spring()) {
                currentStep += 1
                if currentStep == 1 {
                    withAnimation(.spring()) {
                        isExpanded = true // Expand the sheet to full screen
                    }
                }
            }
        } else {
            withAnimation(.spring()) {
                currentStep += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring()) {
                        showAverageRating = true
                    }
                }
            }
        }
    }

    private func ratingColor(averageRating: Double) -> Color {
        switch averageRating {
        case 0..<4: return .red
        case 4..<7: return .orange
        case 7...10: return .green // Include 10 in the green range
        default: return .gray
        }
    }
}





struct RatingHeader: View {
    let title: String
    let subheadline: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            if !subheadline.isEmpty {
                Text(subheadline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 5)
    }
}

struct SelectedRatingHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.bottom, 2)
            .frame(maxWidth: .infinity, alignment: .center) // Center align the text
    }
}
 

struct ReviewRatingView_Previews: PreviewProvider {
    @State static var isExpanded = false
    
    static var previews: some View {
        ReviewRatingView(placeName: "Test Place", placeLocation: "Test Location", isExpanded: $isExpanded)
    }
}
