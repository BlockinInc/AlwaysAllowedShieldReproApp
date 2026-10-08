import FamilyControls
import ManagedSettings
import os
import SwiftUI

@main
struct AlwaysAllowedShieldReproApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private let logger = Logger(subsystem: "com.example.AlwaysAllowedShieldRepro", category: "Shield")

struct ContentView: View {
    @ObservedObject private var authorizationCenter = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()

    @State private var isShielding = false
    @State private var lastEvent = "-"

    var body: some View {
        List {
            Section("Status") {
                LabeledContent("Authorization", value: String(describing: authorizationCenter.authorizationStatus))
                LabeledContent("Shielding", value: isShielding ? "Yes" : "No")
                LabeledContent("Last event", value: lastEvent)
            }
            Section {
                Button("Request Authorization") {
                    Task {
                        do {
                            try await authorizationCenter.requestAuthorization(for: .individual)
                        } catch {
                            logger.error("requestAuthorization failed: \(error.localizedDescription, privacy: .public)")
                        }
                    }
                }
                Button("Start Shield") {
                    // Shield every application category with no exclusions.
                    // Apps in Screen Time > Always Allowed are expected to stay unshielded.
                    store.shield.applicationCategories = .all()
                    record("Start Shield")
                }
                Button("Stop Shield") {
                    store.clearAllSettings()
                    record("Stop Shield")
                }
            }
        }
        .onAppear {
            isShielding = store.shield.applicationCategories != nil
        }
    }

    private func record(_ event: String) {
        let timestamp = Date.now.ISO8601Format()
        logger.notice("\(event, privacy: .public) at \(timestamp, privacy: .public)")
        isShielding = store.shield.applicationCategories != nil
        lastEvent = "\(event) at \(timestamp)"
    }
}
