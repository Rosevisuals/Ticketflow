//
//  BuyerAuthView.swift
//  Ticketflow
//
//  Created by Rose Visuals on 19/04/2026.
//

// BuyerAuthView.swift
// Ticketflow
// Matches Figma: light bg, step-by-step email → password → DOB
// Pink CTA, back chevron, keyboard-aware

import SwiftUI

enum AuthStep {
    case email, password, dateOfBirth
}

struct BuyerAuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    let role: UserRole

    @State private var step: AuthStep = .email
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var dateOfBirth: Date = Calendar.current.date(
        byAdding: .year, value: -18, to: Date()
    ) ?? Date()
    @State private var showDatePicker: Bool = false
    @FocusState private var fieldFocused: Bool
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool

    // replace your entire body in BuyerAuthView with this

    var body: some View {
        ZStack {
            Color(hex: "F5F5F5").ignoresSafeArea()

            VStack(spacing: 0) {

                // top bar
                HStack {
                    if step != .email {
                        Button {
                            withAnimation(.easeInOut) {
                                switch step {
                                case .password: step = .email
                                case .dateOfBirth: step = .password
                                default: break
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .medium))
                        }
                    } else {
                        Color.clear.frame(width: 24)
                    }
                    Spacer()
                    Text("Create account")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                  
                    Color.clear.frame(width: 24)
                }
                .padding(.horizontal, 24)
//                .padding(.top, 16)
//                .padding(.bottom, 502)

                // step content pushed to top
                VStack(alignment: .leading, spacing: 0) {
                    stepContent
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 480)
                .animation(.easeInOut(duration: 0.25), value: step)
                
                Spacer() // pushes button to bottom

                // error
                if let error = authVM.errorMessage {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "E24B4A"))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                }

                // pink CTA always at bottom
                Button {
                    handleNext()
                } label: {
                    Text(step == .dateOfBirth ? "Create account" : "Next")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            isNextEnabled
                            ? Color(hex: "D4537E")
                            : Color(hex: "D4537E").opacity(0.4)
                        )
                        .cornerRadius(40)
                }
                .disabled(!isNextEnabled)
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
    }
    // MARK: - Step Content
    @ViewBuilder
    var stepContent: some View {
        switch step {
        case .email:
            emailStep
        case .password:
            passwordStep
        case .dateOfBirth:
            dobStep
        }
    }

    var emailStep: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter your email")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 20)

            AuthField(
                placeholder: "your@email.com",
                text: $email,
                isSecure: false,
                isFocused: $emailFocused
            )
            .onAppear { emailFocused = true }

            Text("You'll need to confirm this email later")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "999999"))
                .padding(.top, 4)
        }
    }

    var passwordStep: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create a password")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 20)

            AuthField(
                placeholder: "••••••••",
                text: $password,
                isSecure: true,
                isFocused: $passwordFocused
            )
            .onAppear { passwordFocused = true }

            Text("Use at least 6 characters")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "999999"))
                .padding(.top, 4)
        }
    }

    var dobStep: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter your date of birth")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 20)

            Button {
                withAnimation { showDatePicker.toggle() }
            } label: {
                HStack {
                    Text(formattedDate)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "999999"))
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(Color(hex: "D4537E"))
                }
                .padding(14)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "E0E0E0"), lineWidth: 1)
                )
            }

            if showDatePicker {
                DatePicker(
                    "",
                    selection: $dateOfBirth,
                    in: ...Calendar.current.date(
                        byAdding: .year, value: -13, to: Date()
                    )!,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color(hex: "D4537E"))
                .background(Color.white)
                .cornerRadius(12)
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Helpers
    var isNextEnabled: Bool {
        switch step {
        case .email: return email.contains("@") && email.contains(".")
        case .password: return password.count >= 6
        case .dateOfBirth: return true
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: dateOfBirth)
    }

    func handleNext() {
        authVM.errorMessage = nil
        switch step {
        case .email:
            withAnimation { step = .password }
        case .password:
            withAnimation { step = .dateOfBirth }
        case .dateOfBirth:
            // all data collected — create account
            authVM.signUp(
                name: "",
                email: email,
                password: password,
                role: role
            )
        }
    }
}

// MARK: - Reusable Auth Field
struct AuthField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    var isFocused: FocusState<Bool>.Binding? = nil

    var body: some View {
        Group {
            if isSecure {
                if let isFocused {
                    SecureField(placeholder, text: $text)
                        .focused(isFocused)
                } else {
                    SecureField(placeholder, text: $text)
                }
            } else {
                if let isFocused {
                    TextField(placeholder, text: $text)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .focused(isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
        }
        .font(.system(size: 15))
        .foregroundColor(.black)
        .padding(14)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "E0E0E0"), lineWidth: 1)
        )
    }
}

