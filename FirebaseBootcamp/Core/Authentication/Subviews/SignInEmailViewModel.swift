//
//  SignInEmailViewModel.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 18.03.2026.
//

import Foundation

@MainActor @Observable
final class SignInEmailViewModel {

	var email = ""
	var password = ""

	func signUp() async throws {
		guard !email.isEmpty, !password.isEmpty else {
			print("No email or password found.")
			return
		}

		let authResults = try await AuthenticationManager.shared.createUser(email: email, password: password)
		try await UserManager.shared.createNewUser(auth: authResults)
	}

	func signIn() async throws {
		guard !email.isEmpty, !password.isEmpty else {
			print("No email or password found.")
			return
		}

		try await AuthenticationManager.shared.signInUser(email: email, password: password)
	}
}
