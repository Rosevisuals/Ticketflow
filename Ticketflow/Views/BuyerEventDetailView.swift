//
//  BuyerEventDetailView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import SwiftUI

struct BuyerEventDetailView: View {
    let event: EventModel
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "111111").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // full bleed poster — no corner radius at top
                    ZStack(alignment: .topLeading) {
                        EventImageView(path: event.bannerImagePath, height: 400)
                            .frame(maxWidth: .infinity)

                        // dark gradient at very bottom of poster
                        VStack {
                            Spacer()
                            LinearGradient(
                                colors: [Color.clear, Color(hex: "111111")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 120)
                        }
                        .frame(height: 400)

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
                        .padding(.leading, 16)
                    }
                    .frame(height: 400)

                    // content on dark background
                    VStack(alignment: .leading, spacing: 0) {

                        // event title
                        Text(event.title)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 14)

                        // date — green
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "2FB86E"))
                            Text(formattedDate(event.date))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "2FB86E"))
                        }
                        .padding(.bottom, 8)

                        // venue
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "888888"))
                            Text(event.location)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "888888"))

                            // limited tickets badge
                            if appVM.availableCapacity(for: event.id) < 30 {
                                HStack(spacing: 4) {
                                    Image(systemName: "ticket")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(hex: "5DCAA5"))
                                    Text("Limited Tickets")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Color(hex: "5DCAA5"))
                                }
                                .padding(.leading, 4)
                            }
                        }
                        .padding(.bottom, 24)

                        // divider
                        Rectangle()
                            .fill(Color(hex: "222222"))
                            .frame(height: 1)
                            .padding(.bottom, 20)

                        // event info section
                        Text("Event info")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 16)

                        // bullet rows — matches Figma icons exactly
                        VStack(alignment: .leading, spacing: 14) {

                            EventInfoRow(
                                icon: "door.left.hand.open",
                                text: "Doors will be open by 7:00pm",
                                textColor: Color(hex: "CCCCCC")
                            )

                            EventInfoRow(
                                icon: "person.circle",
                                text: "This event is 18+",
                                textColor: Color(hex: "666666")
                            )

                            // refund row with sub bullets
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "creditcard")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "666666"))
                                        .frame(width: 18)
                                    Group {
                                        Text("You can ")
                                            .foregroundColor(Color(hex: "666666")) +
                                        Text("get a refund")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold) +
                                        Text(" if:")
                                            .foregroundColor(Color(hex: "666666"))
                                    }
                                    .font(.system(size: 13))
                                }

                                // sub bullet
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "555555"))
                                        .padding(.leading, 28)
                                    Text("It's within 24 hours of buying tickets")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "666666"))
                                }
                            }

                            EventInfoRow(
                                icon: "megaphone",
                                text: "Presented by AURA",
                                textColor: Color(hex: "666666")
                            )
                        }
                        .padding(.bottom, 100) // space for floating CTA
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 20)
                }
            }
            .ignoresSafeArea(edges: .top)

            // floating bottom CTA — matches Figma exactly
            // "Get Tickets" left, price + button right
            VStack(spacing: 0) {
                // subtle top border
                Rectangle()
                    .fill(Color(hex: "222222"))
                    .frame(height: 1)

                HStack(alignment: .center) {
                    Text("Get Tickets")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Button {} label: {
                        Text("UGX 5,000")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(hex: "D4537E"))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(hex: "111111"))
                .padding(.bottom, 8)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE d MMMM"
        return f.string(from: date)
    }
}

// MARK: - Event Info Row
struct EventInfoRow: View {
    let icon: String
    let text: String
    var textColor: Color = Color(hex: "888888")

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "666666"))
                .frame(width: 18)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(textColor)
                .lineSpacing(3)
        }
    }
}
