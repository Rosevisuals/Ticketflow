//
//  EventViewModel.swift
//  Ticketflow
//
//  Created by Rose Visuals on 13/04/2026.
//
//


import Foundation

internal import Combine

class EventViewModel: ObservableObject {

    // MARK: - Published State
    @Published var events: [EventModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Create Event (Agent only)
    func createEvent(
        title: String,
        description: String,
        date: Date,
        location: String,
        totalCapacity: Int,
        organizerId: UUID
    ) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Event title cannot be empty."
            return
        }

        guard date > Date() else {
            errorMessage = "Event date must be in the future."
            return
        }

        guard totalCapacity > 0 else {
            errorMessage = "Capacity must be at least 1."
            return
        }

        let newEvent = EventModel(
            title: title,
            description: description,
            date: date,
            location: location,
            totalCapacity: totalCapacity,
            organizerId: organizerId
        )

        events.append(newEvent)
        errorMessage = nil
    }

    // MARK: - Update Event (Agent only)
    func updateEvent(id: UUID, title: String, description: String, date: Date, location: String) {
        guard let index = events.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Event not found."
            return
        }

        guard date > Date() else {
            errorMessage = "Event date must be in the future."
            return
        }

        events[index].title = title
        events[index].description = description
        events[index].date = date
        events[index].location = location
        errorMessage = nil
    }

    // MARK: - Delete Event (Agent only)
    func deleteEvent(id: UUID) {
        events.removeAll { $0.id == id }
    }

    // MARK: - Fetch Helpers

    // agent sees only their events
    func events(for organizerId: UUID) -> [EventModel] {
        events
            .filter { $0.organizerId == organizerId }
            .sorted { $0.createdAt > $1.createdAt }
    }

    // viewer sees all upcoming events
    var upcomingEvents: [EventModel] {
        events
            .filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
    }

    // MARK: - Availability Check
    // TicketViewModel will call this before allowing a purchase
    func hasAvailableCapacity(eventId: UUID, soldCount: Int) -> Bool {
        guard let event = events.first(where: { $0.id == eventId }) else { return false }
        return soldCount < event.totalCapacity
    }

    // MARK: - Computed
    var totalEvents: Int {
        events.count
    }
}

