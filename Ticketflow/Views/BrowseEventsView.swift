//
//  BrowseEventsView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//
// BrowseEventsView.swift
import SwiftUI
// BrowseEventsView.swift — replace stub
import SwiftUI
struct BrowseEventsView: View {
    @EnvironmentObject var appVM: AppViewModel
    var body: some View {
        BuyerHomeView()
            .environmentObject(appVM)
    }
}
