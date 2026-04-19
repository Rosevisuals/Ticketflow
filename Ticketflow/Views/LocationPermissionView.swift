// LocationPermissionView.swift
// Ticketflow
// Matches Figma: white bg, illustration, two CTAs
// Handles both GPS location + manual city selection

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var showManualPicker: Bool = false
    @State private var searchText: String = ""

    // called when location setup is done (either way)
    var onComplete: () -> Void

    let cities = [
        "Canada", "Toronto", "France", "Paris",
        "South Africa", "Nigeria", "Kenya",
        "Uganda", "Rwanda", "Ghana",
        "United States", "London", "Malaysia"
    ]

    var filteredCities: [String] {
        searchText.isEmpty ? cities : cities.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            if showManualPicker {
                manualPickerSheet
            } else {
                mainContent
            }
        }
    }

    // MARK: - Main Screen
    var mainContent: some View {
        VStack(spacing: 0) {
            // skip
            HStack {
                Spacer()
                Button("Skip") {
                    onComplete()
                }
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "999999"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer()

            // illustration
            Image("location_illustration")
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .padding(.bottom, 32)

            // heading
            VStack(spacing: 8) {
                Text("See What's\nNear You")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text("Find out what's happening in your area")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "999999"))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 40)

            Spacer()

            // CTAs
            VStack(spacing: 12) {
                // primary — use GPS
                Button {
                    appVM.requestLocation()
                    // after permission granted, onComplete fires
                    // via appVM location delegate
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onComplete()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                        Text("Use your location")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "D4537E"))
                    .cornerRadius(40)
                }

                // secondary — choose manually
                Button {
                    withAnimation(.easeInOut) {
                        showManualPicker = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14))
                        Text("Choose location")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "333333"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color(hex: "E0E0E0"), lineWidth: 1.5)
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }

    // MARK: - Manual City Picker
    var manualPickerSheet: some View {
        VStack(spacing: 0) {
            // search bar
            HStack(spacing: 10) {
                Button {
                    withAnimation { showManualPicker = false }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 14, weight: .medium))
                }

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(hex: "999999"))
                        .font(.system(size: 14))
                    TextField("Where do you want to go?", text: $searchText)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(hex: "F5F5F5"))
                .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider()

            // city list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredCities, id: \.self) { city in
                        Button {
                            // store chosen city in appVM
                            appVM.manualLocationName = city
                            onComplete()
                        } label: {
                            Text(city)
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                        }
                        Divider()
                            .padding(.leading, 20)
                    }
                }
            }
        }
        .background(Color.white)
        .transition(.move(edge: .bottom))
    }
}