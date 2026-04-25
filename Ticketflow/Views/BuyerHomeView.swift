//
//  BuyerHomeView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import SwiftUI

struct BuyerHomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedFilter: String = "Popular"
    @State private var selectedEvent: EventModel? = nil

    let filters = ["Popular", "Nearby"]

    var displayEvents: [EventModel] {
        appVM.eventsSortedByDistance()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "111111").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // pink top bar — bleeds into status bar
                    topBar

                    // gradient fade pink → black + filter chips
                    filterChips

                    // hero event card
                    if let heroEvent = displayEvents.first {
                        HeroEventCard(event: heroEvent) {
                            selectedEvent = heroEvent
                        }
                        .environmentObject(appVM)
                        .padding(.horizontal, 14)
                        .padding(.bottom, 20)
                    } else {
                        placeholderHero
                            .padding(.horizontal, 14)
                            .padding(.bottom, 20)
                    }

                    // weekly events section
                    weeklySection

                    // bottom spacing so content clears the tab bar
                    Spacer().frame(height: 110)
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color(hex: "111111"))

            // frosted tab bar floating at bottom
            tabBar
        }
        .sheet(item: $selectedEvent) { event in
            BuyerEventDetailView(event: event)
                .environmentObject(appVM)
        }
    }

    // MARK: - Top Bar (solid pink)
    var topBar: some View {
        HStack(spacing: 10) {
            Image("logoticketflow")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .colorMultiply(.white)

            Text("Discover")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            Button {} label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 7, height: 7)
                        .offset(x: 2, y: -1)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 56)
        .padding(.bottom, 14)
        .background(Color(hex: "D4537E"))
    }

    // MARK: - Filter Chips with gradient fade pink → black
    var filterChips: some View {
        ZStack(alignment: .top) {
            // multi-stop gradient — pink fades smoothly into black
            LinearGradient(
                colors: [
                    Color(hex: "D4537E"),
                    Color(hex: "C03A6A"),
                    Color(hex: "7a1a3a"),
                    Color(hex: "2a0818"),
                    Color(hex: "111111")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 90)

            // chips sit on top of gradient
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
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(
                                                    Color.white.opacity(0.6),
                                                    lineWidth: 1
                                                )
                                        )
                                )
                        }
                    }

                    // Categories dropdown
                    Button {} label: {
                        HStack(spacing: 5) {
                            Text("Categories")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            Color.white.opacity(0.6),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 20)
            }
        }
    }

    // MARK: - Placeholder when no events
    var placeholderHero: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "1a1a1a"))
            .frame(height: 360)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "ticket")
                        .font(.system(size: 36))
                        .foregroundColor(Color(hex: "333333"))
                    Text("No events near you yet")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "555555"))
                }
            )
    }

    // MARK: - Weekly Events Section
    var weeklySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Catch Up on This Week's Events")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(displayEvents) { event in
                        WeeklyEventCard(event: event) {
                            selectedEvent = event
                        }
                    }
                }
                .padding(.horizontal, 14)
            }
        }
    }

    // MARK: - Frosted Tab Bar
    var tabBar: some View {
        ZStack(alignment: .bottom) {
            // gradient fade transparent → black behind tab bar
            LinearGradient(
                colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.5),
                    Color.black.opacity(0.92)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 130)
            .allowsHitTesting(false)

            // tab bar pill
            HStack(spacing: 0) {

                // Discover — active with dark pill
                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Discover")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color(hex: "2a2a2a"))
                    )
                }

                Spacer()

                // Tickets
                Button {} label: {
                    VStack(spacing: 3) {
                        Image(systemName: "ticket")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "888888"))
                        Text("Tickets")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "888888"))
                    }
                }

                Spacer()

                // Profile
                Button {} label: {
                    VStack(spacing: 3) {
                        Image(systemName: "person")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "888888"))
                        Text("Profile")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "888888"))
                    }
                }

                Spacer()

                // Search — pink circle button
                Button {} label: {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "D4537E"))
                            .frame(width: 44, height: 44)
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: "1a1a1a").opacity(0.96))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.07), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Hero Event Card
struct HeroEventCard: View {
    let event: EventModel
    var onTap: () -> Void
    @EnvironmentObject var appVM: AppViewModel

    var body: some View {
        ZStack(alignment: .bottom) {

            // poster image
            EventImageView(path: event.bannerImagePath, height: 360)
                .cornerRadius(16)

            // dark gradient overlay at bottom of card
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.65)],
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(16)

            // bottom info overlay
            VStack(alignment: .leading, spacing: 10) {

                // venue + organiser row
                HStack(spacing: 6) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down.to.line")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                        Text("AURA LOUNGE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Text("·")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 12))

                    Text("KOLOLO")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    if appVM.availableCapacity(for: event.id) < 30 {
                        Text("Limited Tickets")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "D4537E").opacity(0.9))
                            .cornerRadius(20)
                    }
                }

                // Details + Buy Ticket buttons
                HStack(spacing: 10) {
                    Button { onTap() } label: {
                        Text("Details")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(
                                                Color.white.opacity(0.4),
                                                lineWidth: 1
                                            )
                                    )
                            )
                    }

                    Button { onTap() } label: {
                        Text("Buy Ticket")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(hex: "D4537E"))
                            )
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .frame(height: 360)
        .onTapGesture { onTap() }
    }
}

// MARK: - Weekly Event Card
struct WeeklyEventCard: View {
    let event: EventModel
    var onTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            EventImageView(path: event.bannerImagePath, height: 120)
                .frame(width: 110)
                .cornerRadius(12)

            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.75)],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 1) {
                Text(event.title)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text(event.location)
                    .font(.system(size: 8))
                    .foregroundColor(Color.white.opacity(0.6))
                    .lineLimit(1)
            }
            .padding(.horizontal, 7)
            .padding(.bottom, 7)
        }
        .frame(width: 110, height: 120)
        .onTapGesture { onTap() }
    }
}

// MARK: - Image Loader
// Tries file system first (agent-uploaded images)
// Falls back to asset catalogue (sample/test images)
struct EventImageView: View {
    let path: String?
    var height: CGFloat = 340

    var body: some View {
        Group {
            if let path = path {
                if let data = FileManager.default.contents(atPath: path),
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else if let uiImage = UIImage(named: path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    placeholderGradient
                }
            } else {
                placeholderGradient
            }
        }
        .frame(height: height)
        .clipped()
    }

    var placeholderGradient: some View {
        LinearGradient(
            colors: [Color(hex: "1a3a1a"), Color(hex: "0a200a")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(height: height)
    }
}
