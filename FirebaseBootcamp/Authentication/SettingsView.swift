//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

@MainActor @Observable
final class SettingsViewModel {

	var authProviders: [AuthProviderOption] = []

	func loadAuthProviders() {
		if let providers = try? AuthenticationManager.shared.getProvider() {
			authProviders = providers
		}
	}

	func signOut() throws {
		try AuthenticationManager.shared.signOut()
	}

	func resetPassword() async throws {
		let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
		guard let email = authUser.email else {
			throw URLError(.fileDoesNotExist)
		}
		try await AuthenticationManager.shared.resetPassword(email: email)
	}

	func updateEmail() async throws {
		let email = "hello123@gmail.com"
		try await AuthenticationManager.shared.updateEmail(email: email)
	}

	func updatePassword() async throws {
		let password = "654321"
		try await AuthenticationManager.shared.updatePassword(password: password)
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
						try viewModel.signOut()
						showSignInView = true
					} catch {
						print("Failed to sign out: \(error)")
					}
				}
			}

			if viewModel.authProviders.contains(.email) {
				emailSection
			}
		}
		.onAppear {
			viewModel.loadAuthProviders()
		}
		.navigationTitle("Settings")
    }
}

private extension SettingsView {

	var emailSection: some View {
		Section {
			Button("Reset password") {
				Task {
					do {
						try await viewModel.resetPassword()
						print("PASSWORD RESET!")
					} catch {
						print("Failed to sign out: \(error)")
					}
				}
			}

			Button("Update password") {
				Task {
					do {
						try await viewModel.updatePassword()
						print("PASSWORD UPDATED!")
					} catch {
						print("Failed to sign out: \(error)")
					}
				}
			}

			Button("Update email") {
				Task {
					do {
						try await viewModel.updateEmail()
						print("EMAIL UPDATED!")
					} catch {
						print("Failed to sign out: \(error)")
					}
				}
			}
		} header: {
			Text("Email functions")
		}
	}
}

#Preview {
	NavigationStack {
		SettingsView(showSignInView: .constant(false))
	}
}
