//
//  Event.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import Foundation
import CoreLocation

struct EventModel: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var location: String
    var totalCapacity: Int
    var bannerImagePath: String?   // local file path — replaces bannerURL
    var organizerId: UUID
    var createdAt: Date
    var latitude: Double?          // for location-based discovery
    var longitude: Double?

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        date: Date,
        location: String,
        totalCapacity: Int,
        bannerImagePath: String? = nil,
        organizerId: UUID,
        createdAt: Date = Date(),
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.totalCapacity = totalCapacity
        self.bannerImagePath = bannerImagePath
        self.organizerId = organizerId
        self.createdAt = createdAt
        self.latitude = latitude
        self.longitude = longitude
    }

    // computed distance from user — used for sorting in viewer home
    func distance(from userLocation: CLLocation) -> CLLocationDistance? {
        guard let lat = latitude, let lon = longitude else { return nil }
        let eventLocation = CLLocation(latitude: lat, longitude: lon)
        return userLocation.distance(from: eventLocation)
    }
}
