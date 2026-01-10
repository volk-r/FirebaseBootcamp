//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

@MainActor @Observable
final class SettingsViewModel {

	func signOut() throws {
		try AuthenticationManager.shared.signOut()
	}
}

struct SettingsView: View {

	@State private var viewModel = SettingsViewModel()
	@Binding var showSignInView: Bool

    var body: some View {
		List {
			Button("Log out") {
				Task {
					do {
						try SettingsViewModel().signOut()
						showSignInView = true
					} catch {
						print("Failed to sign out: \(error)")
					}
				}
			}
		}
		.navigationTitle("Settings")
    }
}

#Preview {
	NavigationStack {
		SettingsView(showSignInView: .constant(false))
	}
}
