//
//  Payment.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//
/// previous synta used was invalid the var status : PaymentStatus(enum: paid, pending, failed )

import Foundation
// proper enum is introduced to be used as the type of status property
enum PaymentStatus: String, Codable, CaseIterable {
    // a safe way tp represent payment state without using lose strings
    case pending
    case completed
    case failed
}
// identifiable lets swiftui uniquely track each payment by id
//coadable makes my model portable thus easy to save, send and load data again and again with not extra work
struct PaymentModel: Identifiable , Codable {
    let id: UUID
    // why the above syntax is used and not the "= UUID()" is because this will be creating a new UUID everytime even when decoding which
    // will not enable me to reload the same user from storage
    var ticketId: UUID
    var amount: Double
    // so instead of using enum directly here it is called and used before it was an invalid status initialization
    var status: PaymentStatus // only valid states are represented
    var paidAt: Date?

    init(id: UUID = UUID(), ticketId: UUID, amount: Double, status: PaymentStatus = .pending, paidAt: Date? = nil) {
        //custom initializer for the model struct,it defines how instances of the model are created, lets us set default values and control which properties are required when creating a new payment
        //default values were provided for some parameters so there is not need to pass them everytime
        self.id = id
        self.ticketId = ticketId
        self.amount = amount
        self.status = status
        self.paidAt = paidAt
    }
}
