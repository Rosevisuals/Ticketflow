//
//  ContentView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authVM = AuthViewModel()
    @StateObject var appVM = AppViewModel()
    @State private var showSplash: Bool = true

    var body: some View {
        Group {
            if showSplash {
                // step 1 — splash
                SplashView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                    }
                }

            } else if !authVM.hasCompletedOnboarding {
                // step 2 — onboarding + role selection
                OnboardingView()
                    .environmentObject(authVM)

            } else if !authVM.isAuthenticated {
                // step 3 — auth
                // pendingRole is set by onboarding, read here
                NavigationStack {
                    BuyerAuthView(role: authVM.pendingRole ?? .viewer)
                        .environmentObject(authVM)
                }

            } else if !appVM.locationSetupDone {
                // step 4 — location permission
                LocationPermissionView {
                    withAnimation(.easeInOut) {
                        appVM.locationSetupDone = true
                    }
                }
                .environmentObject(appVM)

            } else if !appVM.notificationSetupDone {
                // step 5 — notification permission
                NotificationPermissionView {
                    withAnimation(.easeInOut) {
                        appVM.notificationSetupDone = true
                    }
                }
                .environmentObject(appVM)

            } else {
                // step 6 — main app
                MainView()
                    .environmentObject(appVM)
                    .environmentObject(authVM)
                    .onAppear {
                        appVM.currentUserId = authVM.currentUser?.id
                        appVM.currentUserRole = authVM.currentUser?.role
                    }
            }
        }
        .animation(.easeInOut, value: showSplash)
        .animation(.easeInOut, value: authVM.isAuthenticated)
        .animation(.easeInOut, value: authVM.hasCompletedOnboarding)
        .animation(.easeInOut, value: appVM.locationSetupDone)
        .animation(.easeInOut, value: appVM.notificationSetupDone)
    }
}

#Preview {
    ContentView()
}
