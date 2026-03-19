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

		let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
		let user = DBUser(auth: authDataResult)
		try await UserManager.shared.createUser(user: user)
	}

	func signIn() async throws {
		guard !email.isEmpty, !password.isEmpty else {
			print("No email or password found.")
			return
		}

		try await AuthenticationManager.shared.signInUser(email: email, password: password)
	}
}
