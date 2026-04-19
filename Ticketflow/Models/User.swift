//
//  User.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import Foundation

enum UserRole : String, Codable, CaseIterable {
    case agent
    case viewer
}
struct UserModel: Identifiable, Codable{
    let id : UUID
    // why the above syntax is used and not the "= UUID()" is because this will be creating a new UUID everytime even when decoding which
    // will not enable me to reload the same user from storage
    var name : String
    var email: String
    var passwordHash : String
    var role:UserRole
    
    init(id: UUID = UUID(), name: String, email: String, passwordHash: String, role: UserRole) {
            self.id = id
            self.name = name
            self.email = email
            self.passwordHash = passwordHash
            self.role = role
        }
}
