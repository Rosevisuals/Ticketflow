//
//  NotificationPermissionView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 19/04/2026.
//

// NotificationPermissionView.swift
// Ticketflow
// Matches Figma: white bg, illustration, Everything / My events only
// iOS system notification dialog triggered on "Everything"

import SwiftUI
import UserNotifications

enum NotificationPreference {
    case everything, myEventsOnly
}

struct NotificationPermissionView: View {
    @State private var selected: NotificationPreference = .everything
    var onComplete: () -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {

                // skip
                HStack {
                    Spacer()
                    Button("Skip") { onComplete() }
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "999999"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // image at top — swap with your asset
                Image("notify")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 260)
                    .padding(.top, 8)

                Spacer() // pushes heading down toward middle

                // heading — pushed below image
                VStack(spacing: 8) {
                    Text("Choose Your\nNotifications")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("You can change this any time in settings")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "999999"))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // options
                VStack(spacing: 12) {
                    NotifOptionRow(
                        icon: "bell.fill",
                        label: "Everything",
                        isSelected: selected == .everything
                    )
                    .onTapGesture {
                        withAnimation(.spring()) { selected = .everything }
                    }

                    NotifOptionRow(
                        icon: "calendar",
                        label: "My events only",
                        isSelected: selected == .myEventsOnly
                    )
                    .onTapGesture {
                        withAnimation(.spring()) { selected = .myEventsOnly }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)

                // CTA
                Button {
                    if selected == .everything {
                        UNUserNotificationCenter.current()
                            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                                DispatchQueue.main.async { onComplete() }
                            }
                    } else {
                        onComplete()
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "D4537E"))
                        .cornerRadius(40)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

// MARK: - Reusable option row
struct NotifOptionRow: View {
    let icon: String
    let label: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isSelected ? Color(hex: "D4537E") : Color(hex: "999999"))
                .frame(width: 24)

            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Circle()
                .fill(isSelected ? Color(hex: "D4537E") : Color.clear)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle().stroke(
                        isSelected ? Color(hex: "D4537E") : Color(hex: "CCCCCC"),
                        lineWidth: 1.5
                    )
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color(hex: "D4537E").opacity(0.06) : Color(hex: "F5F5F5"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? Color(hex: "D4537E").opacity(0.4) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
    }
}
