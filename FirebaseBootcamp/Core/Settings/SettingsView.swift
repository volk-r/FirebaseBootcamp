//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

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

			Button(role: .destructive, action: {
				Task {
					do {
						try await viewModel.deleteAccount()
						showSignInView = true
					} catch {
						print("Failed to delete account: \(error)")
					}
				}
			}, label: {
				Text("Delete account")
			})

			if viewModel.authProviders.contains(.email) {
				emailSection
			}

//			if viewModel.authUser?.isAnonymous == true {
				anonymousSection
//			}
		}
		.onAppear {
			viewModel.loadAuthProviders()
			viewModel.loadAuthUser()
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

	var anonymousSection: some View {
		Section {
			Button("Link Google Account") {
				Task {
					do {
						try await viewModel.linkGoogleAccount()
						print("GOOGLE LINKED!")
					} catch {
						print("Failed to linked: \(error)")
					}
				}
			}

			Button("Link Email Account") {
				Task {
					do {
						try await viewModel.linkEmailAccount()
						print("EMAIL LINKED!")
					} catch {
						print("Failed to linked: \(error)")
					}
				}
			}
		} header: {
			Text("Create Account")
		}
	}
}

#Preview {
	NavigationStack {
		SettingsView(showSignInView: .constant(false))
	}
}
