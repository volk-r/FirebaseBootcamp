//
//  SettingsViewModel.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 18.03.2026.
//

import Foundation

@MainActor @Observable
final class SettingsViewModel {

	var authProviders: [AuthProviderOption] = []
	var authUser: AuthDataResultModel? = nil

	func loadAuthUser() {
		self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
	}

	func loadAuthProviders() {
		if let providers = try? AuthenticationManager.shared.getProvider() {
			authProviders = providers
		}
	}

	func signOut() throws {
		try AuthenticationManager.shared.signOut()
	}

	func deleteAccount() async throws {
		try await AuthenticationManager.shared.delete()
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

	func linkGoogleAccount() async throws {
		let helper = SignInGoogleHelper()
		let tokens = try await helper.signIn()
		self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
	}

	func linkEmailAccount() async throws {
		let email = "hello123@gmail.com"
		let password = "654321"
		self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
	}
}
