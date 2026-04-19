//
//  Ticket.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import Foundation

enum TicketStatus : String, Codable, CaseIterable {
    case pending
    case confirmed
    case cancelled
}
enum TicketTier : String, Codable, CaseIterable {
    case regular
    case vip
    case earlybird
}
struct TicketModel: Identifiable, Codable {
    let id: UUID
    
    var eventId: UUID
    var userId: UUID
    var qrCode: String
    var status: TicketStatus
    var tier: TicketTier
    var purchasedAt: Date

    init(
        id: UUID = UUID(),
        eventId: UUID,
        userId: UUID,
        qrCode: String,
        status: TicketStatus = .pending,
        tier: TicketTier,
        purchasedAt: Date = Date()
    ) {
        self.id = id
        self.eventId = eventId
        self.userId = userId
        self.qrCode = qrCode
        self.status = status
        self.tier = tier
        self.purchasedAt = purchasedAt
    }
}
    
