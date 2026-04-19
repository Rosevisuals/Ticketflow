//
//  SplashView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 19/04/2026.
//
// Animated splash — TF mark grows then wordmark fades in

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.4
    @State private var opacity: Double = 0
    @State private var wordmarkOpacity: Double = 0
    @State private var wordmarkOffset: CGFloat = 10

    var onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 12) {
                // TF logomark — use your actual asset name
                Image("Logo_ticketflow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .scaleEffect(scale)
                    .opacity(opacity)

                // wordmark fades in after mark
                Text("TicketFlow")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.black)
                    .opacity(wordmarkOpacity)
                    .offset(y: wordmarkOffset)
            }
        }
        .onAppear {
            // step 1 — mark appears
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            // step 2 — wordmark slides up and fades in
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                wordmarkOpacity = 1.0
                wordmarkOffset = 0
            }
            // step 3 — navigate after 2s
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinished()
            }
        }
    }
}
