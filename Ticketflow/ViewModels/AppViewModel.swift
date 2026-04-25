//
//  AppViewModel.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

import Foundation
import CoreLocation

internal import Combine

class AppViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Published State
    @Published var events: [EventModel] = []
    @Published var tickets: [TicketModel] = []
    @Published var payments: [PaymentModel] = []
    @Published var userLocation: CLLocation? = nil
    @Published var locationPermissionDenied: Bool = false
    @Published var locationSetupDone: Bool = false
    @Published var notificationSetupDone: Bool = false
    @Published var manualLocationName: String? = nil

    var currentUserId: UUID?
    var currentUserRole: UserRole?

    private let locationManager = CLLocationManager()

    // MARK: - Init
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        loadSampleEvents()
    }

    // MARK: - Location
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            locationPermissionDenied = true
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    // MARK: - Capacity Coordination
    func availableCapacity(for eventId: UUID) -> Int {
        guard let event = events.first(where: { $0.id == eventId }) else { return 0 }
        let sold = tickets.filter {
            $0.eventId == eventId && $0.status == .confirmed
        }.count
        return event.totalCapacity - sold
    }

    // MARK: - Events Sorted by Distance
    func eventsSortedByDistance() -> [EventModel] {
        guard let userLocation = userLocation else {
            return events.filter { $0.date > Date() }
        }
        return events
            .filter { $0.date > Date() }
            .sorted {
                let d1 = $0.distance(from: userLocation) ?? .greatestFiniteMagnitude
                let d2 = $1.distance(from: userLocation) ?? .greatestFiniteMagnitude
                return d1 < d2
            }
    }

    // MARK: - Image Persistence
    func saveBannerImage(_ imageData: Data, for eventId: UUID) -> String? {
        let filename = "banner_\(eventId.uuidString).jpg"
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
        do {
            try imageData.write(to: url)
            return url.path
        } catch {
            print("Failed to save banner: \(error)")
            return nil
        }
    }

    func loadBannerImage(from path: String) -> Data? {
        return FileManager.default.contents(atPath: path)
    }

    func deleteBannerImage(at path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }

    // MARK: - Sample Data
    // Remove this when real agent-created events exist
    private func loadSampleEvents() {
        events = [
            EventModel(
                title: "After Work Vibes",
                description: "A party for the youth's Gen Z from work who wish to relax their minds from the boring day they had.",
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                location: "AURA Lounge · Kololo",
                totalCapacity: 200,
                // use your asset catalogue image name here
                bannerImagePath: "art",
                organizerId: UUID(),
                latitude: 0.3136,
                longitude: 32.5811
            ),
            EventModel(
                title: "Hip Hop Night",
                description: "The biggest hip hop night in Kampala. Live performances, DJ sets and more.",
                date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                location: "Skyz Hotel · Naguru",
                totalCapacity: 300,
                bannerImagePath: "colorful",
                organizerId: UUID(),
                latitude: 0.3200,
                longitude: 32.5900
            ),
            EventModel(
                title: "Reggae Fridays",
                description: "Every Friday night. Good vibes only.",
                date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                location: "Cayenne · Kampala",
                totalCapacity: 150,
                bannerImagePath: "disc",
                organizerId: UUID(),
                latitude: 0.3150,
                longitude: 32.5750
            ),
            EventModel(
                title: "Jazz & Wine Evening",
                description: "An intimate evening of live jazz paired with fine wines.",
                date: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
                location: "Serena Hotel · Kampala",
                totalCapacity: 100,
                bannerImagePath: "black",
                organizerId: UUID(),
                latitude: 0.3180,
                longitude: 32.5820
            ),
            EventModel(
                title: "Amapiano Sunday",
                description: "The best amapiano artists in East Africa, all under one roof.",
                date: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
                location: "Kololo Airstrip · Kampala",
                totalCapacity: 500,
                bannerImagePath: "party",
                organizerId: UUID(),
                latitude: 0.3100,
                longitude: 32.5800
            )
        ]
    }
}
