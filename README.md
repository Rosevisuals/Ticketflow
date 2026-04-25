# Ticketflow 🎟️
### An iOS event ticketing app built with SwiftUI + MVVM

> Designed in Figma. Built from scratch in Xcode. Architected for scale.
<img width="3200" height="4000" alt="T1" src="https://github.com/user-attachments/assets/0a685a21-9de3-4b47-888d-3b8e03290ee5" />
## Overview

Ticketflow is an iOS application that connects event organisers and ticket buyers in one seamless experience. Organisers create and manage events, track attendance, and verify tickets on the door. Buyers discover events near them, purchase tickets, and access QR codes instantly from their phones.

Built specifically for the East African market — with UGX pricing, local venue context, and MTN Mobile Money / Airtel Money payment support planned for v2.

---

## The Problem

Event ticketing in Uganda is fragmented. Organisers manage guest lists manually, buyers pay via mobile money with no digital record, and ticket verification at the door is slow and error-prone. Ticketflow solves all three.

---

## Role

Solo designer and developer. Responsible for the full product — research, architecture, UI/UX design, and SwiftUI implementation.

---

## Design Process

### Research & Strategy
Started by mapping the East African events landscape — identifying that the real gap wasn't just ticketing but the connection between discovery, purchase, and venue check-in in a single native experience.

Identified two core user roles with fundamentally different needs:
- **Agent (Event Organiser)** — needs dashboard, event creation, attendee management, QR scanning
- **Buyer** — needs discovery, location-aware search, frictionless checkout, offline QR ticket access

### Figma Design
Designed 13+ screens across both roles before writing a line of Swift. Key design decisions:

- **Color palette** — Black `#111111` base, Pink `#D4537E` for primary actions, Teal `#5DCAA5` for secondary accents. High contrast, event-poster energy.
- **Full-bleed event posters** — Buyers need visual pull on the discovery screen. Poster-style cards create that without sacrificing information density.
- **Role-separated flows** — Agent and Buyer see entirely different home screens post-login. No role confusion.
- **Frosted glass tab bar** — Custom floating tab bar with gradient fade, matching modern iOS aesthetics without using the default `TabView`.


<img width="3200" height="4000" alt="T1" src="https://github.com/user-attachments/assets/abe8785b-aa5f-4326-bf4e-fab0c35b56f8" />
<img width="3200" height="4000" alt="t2" src="https://github.com/user-attachments/assets/db767442-2ab1-4ecf-acc3-4bf921502d27" />
<img width="3200" height="4000" alt="t3" src="https://github.com/user-attachments/assets/0051b658-3fee-453b-a56c-c14c8c1557bb" />
<img width="3200" height="4000" alt="t4" src="https://github.com/user-attachments/assets/ea4ee11c-7bad-4430-a6c5-ffdfc7c697e1" />
<img width="1024" height="1024" alt="Frame 5" src="https://github.com/user-attachments/assets/fcea6235-985b-4656-91b3-b51aa66016ff" />
<img width="1024" height="1024" alt="Frame 4" src="https://github.com/user-attachments/assets/59bf6eaa-1859-4071-b0c7-486f82ff2cea" />

## Architecture

Built on **MVVM (Model-View-ViewModel)** with a parent `AppViewModel` coordinating shared state across the app.

```
Models          → UserModel, EventModel, TicketModel, PaymentModel
ViewModels      → AuthViewModel, AppViewModel, EventViewModel, PaymentViewModel
Views           → 13+ screens across Agent, Buyer, and Shared flows
```

### Key Architecture Decisions

**Single source of truth via `AppViewModel`**
Instead of having ViewModels talk to each other directly (tight coupling), all shared state — events, tickets, payments, location, user role — lives in `AppViewModel`. Child ViewModels are focused action handlers. When the backend arrives, only `AppViewModel` needs updating.

**State-driven navigation via `@Published`**
Every screen transition is driven by a published flag, not imperative navigation calls:

```swift
hasCompletedOnboarding → isAuthenticated → locationSetupDone → notificationSetupDone
```

Each flag flips, the UI reacts. No navigation stack hacks.

**Local-first with clear migration path**
All data is stored locally for v1 — `UserDefaults` for session, `FileManager` documents directory for agent-uploaded event banners, in-memory arrays for events and tickets. Every storage point is isolated in `AppViewModel`, so swapping in API calls later requires changing one file, not ten.

**Dual image loading**
`EventImageView` tries the file system first (agent-uploaded images), then falls back to the asset catalogue (sample/test images). Agents pick banners from their photo library via `PhotosPicker` — images are saved to the documents directory and the file path stored in `EventModel.bannerImagePath`.

---

## Technical Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9 |
| UI Framework | SwiftUI |
| Architecture | MVVM |
| State Management | `@Published` / `ObservableObject` |
| Location | CoreLocation |
| Notifications | UserNotifications |
| Image Picking | PhotosUI / PhotosPicker |
| Password Hashing | CryptoKit / SHA256 |
| Local Storage | FileManager / UserDefaults |
| Design Tool | Figma |

---

## App Flow

```
Launch
  └── SplashView (animated TF logomark)
        └── OnboardingView (welcome + role selection)
              └── BuyerAuthView (email → password → date of birth)
                    └── LocationPermissionView (GPS or manual city picker)
                          └── NotificationPermissionView
                                ├── BuyerHomeView (Discover tab)
                                │     └── BuyerEventDetailView (full-bleed poster + info)
                                └── AgentDashboardView (events overview)
```

---

## Screens Built

### Buyer Flow
- Splash screen with animated logo sequence
- Onboarding — welcome illustration + role selection
- Auth — step-by-step email → password → date of birth
- Location permission — GPS or manual city/country picker (60+ locations)
- Notification preference selection
- Discover home — full-bleed hero poster, filter chips, weekly events scroll
- Event detail — full-bleed poster, event info, refund policy, floating CTA
- My Tickets — QR code access (in progress)
- Checkout — tier selection, quantity, MTN MoMo / Airtel Money (in progress)

### Agent Flow
- Agent dashboard — event stats, ticket sales, revenue summary
- Create event — form with banner image upload via PhotosPicker
- Event detail — attendee list, ticket breakdown
- Edit event
- QR scanner — verify tickets at the door (in progress)

### Shared
- Profile / account settings
- Notifications
- Search & filter

---

## What's Next (v2)

- Backend API integration (Node.js / Supabase)
- MTN Mobile Money + Airtel Money payment processing
- Real-time ticket verification
- Spotify integration — personalised event recommendations based on listening history
- Push notifications for event updates

---

## Lessons Learned

**Design before you build.** Having 13 screens fully designed in Figma before touching Xcode meant architectural decisions were made with full context — not discovered mid-build.

**State management is architecture.** The decision to use `@Published` flags for navigation instead of programmatic `NavigationPath` manipulation made the entire flow easier to reason about, debug, and extend.

**Local-first is a feature, not a compromise.** Building offline-capable from day one means the app works in low-connectivity environments — which matters in Kampala.

**Type consistency saves hours.** Every model ID is `UUID`. Every foreign key reference is `UUID`. One inconsistency (`eventId: String` instead of `UUID`) caused a cascade of compiler errors that took longer to debug than it would have taken to be consistent from the start.

---

## Author

**Rose Visuals** — UI/UX Designer & iOS Developer
Based in Kampala, Uganda 🇺🇬

[LinkedIn]((https://www.linkedin.com/in/namubiru-rose-389a11253?utm_source=share_via&utm_content=profile&utm_medium=member_ios)) · · [Figma Portfolio](https://www.instagram.com/rose_app_designs?igsh=MWV3d3N0Z2gyZ2pkZw%3D%3D&utm_source=qr)

---

*Ticketflow is an independent portfolio project. Not affiliated with any existing ticketing platform.*
