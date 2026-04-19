//
//  OnboardingView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showRoleSelection: Bool = false

    var body: some View {
        ZStack {
            if showRoleSelection {
                RoleSelectionView(onRoleSelected: { role in
                    authVM.pendingRole = role
                    authVM.hasCompletedOnboarding = true
                })
                .transition(.move(edge: .trailing))
            } else {
                WelcomeScreen(onGetStarted: {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showRoleSelection = true
                    }
                })
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showRoleSelection)
    }
}

// MARK: - Screen 1: Welcome
struct WelcomeScreen: View {
    var onGetStarted: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a0010"), Color(hex: "3d0030"), Color(hex: "111111")],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()

            // vertical stripes
            HStack(spacing: 0) {
                ForEach(Array(0..<12), id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.03))
                        .frame(maxWidth: .infinity)
                
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // top bar
                HStack {
                    HStack(spacing: 6) {
                        Image("logoticketflow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .colorMultiply(.white)
                        Text("TicketFlow")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)

                Spacer()

                // illustration
                Image("house_party")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 320)
                    .padding(.bottom, 40)

                // tagline
                VStack(alignment: .leading, spacing: 8) {
                    Text("Events Made\nEffortless")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .lineSpacing(4)

                    Text("Manage your events & buy tickets\nall in one place.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.5))
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                Spacer()

                // CTA
                Button {
                    onGetStarted()
                } label: {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // sign in link
                Button {
                    // already have account — handled in ContentView
                    // for now this is a placeholder
                } label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(Color.white.opacity(0.4))
                        Text("Sign in")
                            .foregroundColor(Color(hex: "D4537E"))
                    }
                    .font(.system(size: 13))
                }
                .padding(.bottom, 48)
            }
        }
    }
}

// MARK: - Screen 2: Role Selection
struct RoleSelectionView: View {
    var onRoleSelected: (UserRole) -> Void
    @State private var selectedRole: UserRole? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a0010"), Color(hex: "3d0030"), Color(hex: "111111")],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()

            // vertical stripes
            HStack(spacing: 0) {
                ForEach(0..<12, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.03))
                        .frame(maxWidth: .infinity)
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // top bar
                HStack {
                    HStack(spacing: 6) {
                        Image("logoticketflow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .colorMultiply(.white)
                        Text("TicketFlow")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 48)

                // heading
                VStack(alignment: .leading, spacing: 8) {
                    Text("I am a...")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text("Choose your role to get started")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)

                // role cards
                VStack(spacing: 14) {
                    RoleCard(
                        icon: "🎪",
                        title: "Event organiser",
                        subtitle: "Create and manage events",
                        isSelected: selectedRole == .agent
                    ) {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            selectedRole = .agent
                        }
                        // brief delay so checkmark animates before transitioning
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            onRoleSelected(.agent)
                        }
                    }

                    RoleCard(
                        icon: "🎫",
                        title: "Buyer",
                        subtitle: "Browse and buy tickets",
                        isSelected: selectedRole == .viewer
                    ) {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            selectedRole = .viewer
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            onRoleSelected(.viewer)
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

// MARK: - Role Card
struct RoleCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Text(icon)
                .font(.system(size: 24))
                .frame(width: 48, height: 48)
                .background(Color.white.opacity(0.08))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.5))
            }

            Spacer()

            // checkbox
            ZStack {
                Circle()
                    .fill(isSelected ? Color(hex: "D4537E") : Color.clear)
                    .frame(width: 22, height: 22)
                Circle()
                    .stroke(
                        isSelected ? Color(hex: "D4537E") : Color.white.opacity(0.3),
                        lineWidth: 1.5
                    )
                    .frame(width: 22, height: 22)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected
                      ? Color(hex: "D4537E").opacity(0.12)
                      : Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isSelected
                            ? Color(hex: "D4537E").opacity(0.6)
                            : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
        .onTapGesture { onTap() }
    }
}
