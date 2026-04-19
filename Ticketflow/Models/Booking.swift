//
//  Booking.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//
import Foundation

struct BookingModel: Identifiable {
    let id : UUID
    // why the above syntax is used and not the "= UUID()" is because this will be creating a new UUID everytime even when decoding which
    // will not enable me to reload the same user from storage
    var eventId: String
    var userId: String
    var quantity: Int
    var totalPrice: Double
}
