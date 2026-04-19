//
//  MainView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.


import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var appVM: AppViewModel

    var body: some View {
        Group {
            if authVM.isAgent {
                AgentDashboardView()
                    .environmentObject(appVM)
                    .environmentObject(authVM)
            } else {
                BrowseEventsView()
                    .environmentObject(appVM)
                    .environmentObject(authVM)
            }
        }
    }
}
