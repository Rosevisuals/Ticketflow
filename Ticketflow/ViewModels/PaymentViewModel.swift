//
//  PaymentViewModel.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//


import Foundation

internal import Combine
// ObservableObject allows SwiftUI views to reactively
// update whenever @Published properties change
class PaymentViewModel: ObservableObject {
    // any view observing this View Model will re-render when these change
    @Published var payments: [PaymentModel] = []
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil

    
    // called when a viewer initiates a ticket purchase
    // returns the created payment so the caller can link it to a ticket
    func initiatePayment(for ticketId: UUID, amount: Double) -> PaymentModel {
        let newPayment = PaymentModel(
            ticketId: ticketId,
            amount: amount,
            status: .pending
        )
        payments.append(newPayment)
        return newPayment
    }

   
    // simulates a successful payment locally
    // when backend is added, this is where your API call lives
    func confirmPayment(id: UUID) {
        guard let index = payments.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Payment not found."
            return
        }
        payments[index].status = .completed
        payments[index].paidAt = Date()
    }

    
    func failPayment(id: UUID) {
        guard let index = payments.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Payment not found."
            return
        }
        payments[index].status = .failed
    }

   
    // useful for the agent viewing all payments on their event's tickets
    func payments(for ticketId: UUID) -> [PaymentModel] {
        payments.filter { $0.ticketId == ticketId }
    }

    // MARK: - Computed Summary (Agent Dashboard use)
    var totalCollected: Double {
        payments
            .filter { $0.status == .completed }
            .reduce(0) { $0 + $1.amount }
    }

    var pendingCount: Int {
        payments.filter { $0.status == .pending }.count
    }
}
