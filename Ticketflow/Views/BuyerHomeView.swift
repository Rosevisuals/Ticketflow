//
//  BuyerHomeView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 19/04/2026.
//
// BuyerHomeView.swift
// Ticketflow
// Matches Figma: pink top bar, TF logo, Discover heading,
// filter chips, full-bleed poster card, weekly events row
// Taps poster → EventDetailView

import SwiftUI

struct BuyerHomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedFilter: String = "Popular"
    @State private var selectedEvent: EventModel? = nil

    let filters = ["Popular", "Nearby", "Categories"]

    // sample events — replace with appVM.eventsSortedByDistance()
    var displayEvents: [EventModel] {
        appVM.eventsSortedByDistance()
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "111111").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // pink top bar
                    topBar
                        .padding(.bottom, 12)

                    // filter chips
                    filterChips
                        .padding(.bottom, 16)

                    // hero event card — first upcoming event
                    if let heroEvent = displayEvents.first {
                        HeroEventCard(event: heroEvent) {
                            selectedEvent = heroEvent
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    } else {
                        emptyState
                    }

                    // weekly events horizontal scroll
                    weeklySection
                        .padding(.bottom, 32)
                }
            }
        }
        .sheet(item: $selectedEvent) { event in
            BuyerEventDetailView(event: event)
                .environmentObject(appVM)
        }
    }

    // MARK: - Top Bar
    var topBar: some View {
        HStack {
            HStack(spacing: 6) {
                Image("tf_logomark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .colorMultiply(Color(hex: "D4537E"))
                Text("Discover")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                // navigate to notifications
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .overlay(
                        Circle()
                            .fill(Color(hex: "D4537E"))
                            .frame(width: 8, height: 8)
                            .offset(x: 6, y: -6)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Filter Chips
    var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(
                                selectedFilter == filter ? .white : Color(hex: "888888")
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(
                                        selectedFilter == filter
                                        ? Color(hex: "D4537E")
                                        : Color(hex: "1a1a1a")
                                    )
                            )
                    }
                }

                // Categories dropdown indicator
                Button {
                } label: {
                    HStack(spacing: 4) {
                        Text("Categories")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(hex: "888888"))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "888888"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(Color(hex: "1a1a1a")))
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Weekly Events Section
    var weeklySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Catch Up on This Week's Events")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(displayEvents.prefix(6)) { event in
                        WeeklyEventCard(event: event) {
                            selectedEvent = event
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Empty State
    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "ticket")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "333333"))
            Text("No events near you yet")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "555555"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Hero Event Card
struct HeroEventCard: View {
    @EnvironmentObject var appVM: AppViewModel
    let event: EventModel
    var onTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            // banner image
            Group {
                if let path = event.bannerImagePath,
                   let data = FileManager.default.contents(atPath: path),
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    // placeholder gradient
                    LinearGradient(
                        colors: [Color(hex: "1f0a18"), Color(hex: "3d1a2e")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .frame(height: 340)
            .clipped()
            .cornerRadius(16)

            // gradient overlay at bottom
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.85)],
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(16)

            // event info overlay
            VStack(alignment: .leading, spacing: 6) {
                // venue + organiser
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "5DCAA5"))
                    Text(event.location.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color(hex: "5DCAA5"))
                        .lineLimit(1)
                    Spacer()
                    // limited tickets badge
                    if appVM.availableCapacity(for: event.id) < 20 {
                        Text("Limited Tickets")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "D4537E"))
                            .cornerRadius(20)
                    }
                }

                // action buttons
                HStack(spacing: 8) {
                    Button {
                        onTap()
                    } label: {
                        Text("Details")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    Button {
                        onTap()
                    } label: {
                        Text("Buy Ticket")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(hex: "D4537E"))
                            .cornerRadius(20)
                    }
                }
            }
            .padding(16)
        }
        .frame(height: 340)
        .onTapGesture { onTap() }
    }
}

// MARK: - Weekly Event Card (horizontal scroll)
struct WeeklyEventCard: View {
    let event: EventModel
    var onTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if let path = event.bannerImagePath,
                   let data = FileManager.default.contents(atPath: path),
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color(hex: "1f0a18")
                }
            }
            .frame(width: 120, height: 160)
            .clipped()
            .cornerRadius(12)

            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text(event.location)
                    .font(.system(size: 8))
                    .foregroundColor(Color.white.opacity(0.6))
                    .lineLimit(1)
            }
            .padding(8)
        }
        .frame(width: 120, height: 160)
        .onTapGesture { onTap() }
    }
}

