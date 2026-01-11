//
//  AuthenticationManager.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import Foundation
import FirebaseAuth

struct AuthDataResult {
	let uid: String
	let email: String?
	let photoUrl: String?

	init(user: User) {
		self.uid = user.uid
		self.email = user.email
		self.photoUrl = user.photoURL?.description
	}
}

final class AuthenticationManager {

	static let shared = AuthenticationManager()

	private init() {}

	func getAuthenticatedUser() throws -> AuthDataResult {
		guard let user = Auth.auth().currentUser else {
			throw URLError(.badServerResponse)
		}

		return AuthDataResult(user: user)
	}

	@discardableResult
	func createUser(email: String, password: String) async throws -> AuthDataResult {
		let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
		return AuthDataResult(user: authDataResult.user)
	}

	@discardableResult
	func signInUser(email: String, password: String) async throws -> AuthDataResult {
		let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
		return AuthDataResult(user: authDataResult.user)
	}

	func resetPassword(email: String) async throws {
		try await Auth.auth().sendPasswordReset(withEmail: email)
	}

	func updatePassword(password: String) async throws {
		guard let user = Auth.auth().currentUser else {
			throw URLError(.badServerResponse)
		}
		try await user.updatePassword(to: password)
	}

	func updateEmail(email: String) async throws {
		guard let user = Auth.auth().currentUser else {
			throw URLError(.badServerResponse)
		}
		try await user.sendEmailVerification(beforeUpdatingEmail: email)
	}

	func signOut() throws {
		try Auth.auth().signOut()
	}
}
