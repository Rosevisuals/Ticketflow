//
//  AuthViewModel.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//


import Foundation
import CryptoKit

internal import Combine

class AuthViewModel: ObservableObject {

    // MARK: - Published State
    @Published var currentUser: UserModel? = nil
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasCompletedOnboarding: Bool = false
    @Published var pendingRole: UserRole? = nil

    // MARK: - Private Local Storage
    // in-memory store for now — SwiftData replaces this later
    // key is email, value is the stored UserModel
    private var localUsers: [String: UserModel] = [:]

    // MARK: - Session Persistence Keys
    private let sessionKey = "ticketflow_session_userID"

    // MARK: - Init — restore session on app launch
    init() {
        restoreSession()
    }

    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String, role: UserRole) {
        // guard against duplicate emails
        guard localUsers[email.lowercased()] == nil else {
            errorMessage = "An account with this email already exists."
            return
        }

        guard isValidPassword(password) else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        let hashed = hash(password)
        let newUser = UserModel(
            name: name,
            email: email.lowercased(),
            passwordHash: hashed,
            role: role
        )

        localUsers[email.lowercased()] = newUser
        persistSession(userID: newUser.id.uuidString)
        currentUser = newUser
        isAuthenticated = true
        errorMessage = nil
    }

    // MARK: - Login
    func login(email: String, password: String) {
        guard let user = localUsers[email.lowercased()] else {
            errorMessage = "No account found with this email."
            return
        }

        guard user.passwordHash == hash(password) else {
            errorMessage = "Incorrect password."
            return
        }

        persistSession(userID: user.id.uuidString)
        currentUser = user
        isAuthenticated = true
        errorMessage = nil
    }

    // MARK: - Logout
    func logout() {
        currentUser = nil
        isAuthenticated = false
        clearSession()
    }

    // MARK: - Role Check Helpers
    // views use these instead of checking role directly
    // makes role enforcement one place to update when backend arrives
    var isAgent: Bool {
        currentUser?.role == .agent
    }

    var isViewer: Bool {
        currentUser?.role == .viewer
    }

    // MARK: - Session Persistence (UserDefaults for now)
    private func persistSession(userID: String) {
        UserDefaults.standard.set(userID, forKey: sessionKey)
    }

    private func restoreSession() {
        // when SwiftData is added, you'll query by saved userID here
        // for now session restores as nil — user logs in each launch
        guard UserDefaults.standard.string(forKey: sessionKey) != nil else { return }
        // TODO: query local store by userID and restore currentUser
    }

    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }

    // MARK: - Helpers
    private func hash(_ input: String) -> String {
        let data = Data(input.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 6
    }
}
