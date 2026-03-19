//
//  AuthenticationViewModel.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 18.03.2026.
//

import Foundation

@MainActor @Observable
final class AuthenticationViewModel {

	func signInGoogle() async throws {
		let helper = SignInGoogleHelper()
		let tokens = try await helper.signIn()
		let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
		let user = DBUser(auth: authDataResult)
		try await UserManager.shared.createUser(user: user)
	}

	func signInAnonymous() async throws {
		let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
		let user = DBUser(auth: authDataResult)
		try await UserManager.shared.createUser(user: user)
	}
}
