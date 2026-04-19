//
//  AppViewModel.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//

// AppViewModel.swift

import Foundation
import CoreLocation

internal import Combine
// the use of this  view model is to act as a parent for the event view model & the payment view model
// why?
// to enable these view models to get what they want from one place that the payment view model to see what goes on in the event view
// model before generating a ticket for payment
class AppViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Published State
    @Published var events: [EventModel] = []
    @Published var tickets: [TicketModel] = []
    @Published var payments: [PaymentModel] = []
    @Published var userLocation: CLLocation? = nil
    @Published var locationPermissionDenied: Bool = false
    @Published var manualLocationName: String? = nil
    @Published var locationSetupDone: Bool = false
    @Published var notificationSetupDone: Bool = false
    
    var currentUserId: UUID?
    var currentUserRole: UserRole?
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Init
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
    // MARK: - Events Near User
       // viewer home screen uses this to sort by proximity
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
       // agent calls this when picking a banner photo
       // returns the saved file path to store in EventModel.bannerImagePath
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

             // viewer/agent calls this to load a banner image from path
             func loadBannerImage(from path: String) -> Data? {
                 return FileManager.default.contents(atPath: path)
             }

             // call this when an event is deleted — cleans up the image file
             func deleteBannerImage(at path: String) {
                 try? FileManager.default.removeItem(atPath: path)
             }
         }

