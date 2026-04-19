//
//  TFField.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//
// TFField.swift — reusable input component used across all forms

import SwiftUI

struct TFField: View {
    let label: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "7775a8"))

            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .font(.system(size: 13))
            .foregroundColor(Color(hex: "c8c6f0"))
            .padding(10)
            .background(Color(hex: "1a1a2e"))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "333333"), lineWidth: 1))
        }
        .padding(.bottom, 10)
    }
}

// Color hex extension — add this once to your project
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
