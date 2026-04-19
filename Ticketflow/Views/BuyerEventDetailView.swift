//
//  BuyerEventDetailView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 19/04/2026.
//

// BuyerEventDetailView.swift
// Ticketflow
// Matches Figma: full banner top, event info, refund policy,
// price + Get Tickets pink CTA

import SwiftUI

struct BuyerEventDetailView: View {
    let event: EventModel
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedTier: TicketTier = .regular

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "111111").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // full banner
                    ZStack(alignment: .topLeading) {
                        Group {
                            if let path = event.bannerImagePath,
                               let data = FileManager.default.contents(atPath: path),
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                LinearGradient(
                                    colors: [Color(hex: "1f0a18"), Color(hex: "3d1a2e")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        }
                        .frame(height: 300)
                        .clipped()

                        // back button
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        .padding(.top, 56)
                        .padding(.leading, 20)
                    }

                    // content card
                    VStack(alignment: .leading, spacing: 0) {

                        // title + meta
                        Text(event.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)

                        // date
                        EventMetaRow(
                            icon: "calendar",
                            text: formattedDate(event.date)
                        )
                        // location
                        EventMetaRow(
                            icon: "mappin.and.ellipse",
                            text: event.location
                        )
                        // limited badge
                        if appVM.availableCapacity(for: event.id) < 20 {
                            EventMetaRow(
                                icon: "ticket",
                                text: "Limited Tickets",
                                color: Color(hex: "D4537E")
                            )
                        }

                        Divider()
                            .background(Color(hex: "222222"))
                            .padding(.vertical, 16)

                        // event info
                        Text("Event info")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "5DCAA5"))
                            .padding(.bottom, 8)

                        VStack(alignment: .leading, spacing: 6) {
                            InfoBullet(text: "Doors will be open by 7:00pm")
                            InfoBullet(text: "This event is 18+")
                            InfoBullet(
                                text: "You can get a refund if:",
                                subBullets: [
                                    "It's within 24 hours of buying tickets",
                                    "The event is cancelled or rescheduled"
                                ]
                            )
                            InfoBullet(text: "Presented by AURA")
                        }
                        .padding(.bottom, 24)

                        // ticket tier selection
                        Text("Select ticket")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "5DCAA5"))
                            .padding(.bottom, 10)

                        VStack(spacing: 8) {
                            ForEach(TicketTier.allCases, id: \.self) { tier in
                                TierRow(
                                    tier: tier,
                                    isSelected: selectedTier == tier,
                                    capacity: appVM.availableCapacity(for: event.id)
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) { selectedTier = tier }
                                }
                            }
                        }
                        .padding(.bottom, 100) // space for floating CTA
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }

            // floating CTA
            VStack(spacing: 0) {
                Divider().background(Color(hex: "222222"))
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "888888"))
                        Text("UGX \(tierPrice(selectedTier))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "D4537E"))
                    }
                    Spacer()
                    Button {
                        // navigate to checkout
                    } label: {
                        Text("Get Tickets")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(Color(hex: "D4537E"))
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(hex: "111111"))
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE d MMMM · h:mm a"
        return f.string(from: date)
    }

    func tierPrice(_ tier: TicketTier) -> String {
        switch tier {
        case .regular: return "5,000"
        case .vip: return "15,000"
        case .earlybird: return "3,000"
        }
    }
}

// MARK: - Supporting Components

struct EventMetaRow: View {
    let icon: String
    let text: String
    var color: Color = Color(hex: "888888")

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(color)
                .frame(width: 18)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(color)
        }
        .padding(.bottom, 8)
    }
}

struct InfoBullet: View {
    let text: String
    var subBullets: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Circle()
                    .fill(Color(hex: "888888"))
                    .frame(width: 4, height: 4)
                    .padding(.top, 6)
                Text(text)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "CCCCCC"))
            }
            if !subBullets.isEmpty {
                ForEach(subBullets, id: \.self) { bullet in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "555555"))
                            .padding(.leading, 16)
                        Text(bullet)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "888888"))
                    }
                }
            }
        }
    }
}

struct TierRow: View {
    let tier: TicketTier
    let isSelected: Bool
    let capacity: Int

    var tierName: String {
        switch tier {
        case .regular: return "Regular"
        case .vip: return "VIP"
        case .earlybird: return "Early Bird"
        }
    }

    var tierDesc: String {
        switch tier {
        case .regular: return "General admission"
        case .vip: return "Front row + drinks"
        case .earlybird: return "Limited availability"
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(tierName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Text(tierDesc)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "666666"))
            }
            Spacer()
            Circle()
                .fill(isSelected ? Color(hex: "D4537E") : Color.clear)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle().stroke(
                        isSelected ? Color(hex: "D4537E") : Color(hex: "444444"),
                        lineWidth: 1.5
                    )
                )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color(hex: "D4537E").opacity(0.1) : Color(hex: "1a1a1a"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isSelected ? Color(hex: "D4537E").opacity(0.5) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
    }
}
