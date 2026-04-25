//
//  BrowseEventsView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import SwiftUI

struct BrowseEventsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        // BuyerHomeView handles its own custom tab bar
        // so we don't wrap in a TabView here —
        // the custom frosted tab bar is built inside BuyerHomeView
        BuyerHomeView()
            .environmentObject(appVM)
    }
}
