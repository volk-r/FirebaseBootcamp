//
//  AuthenticationManager.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
	let uid: String
	let email: String?
	let photoUrl: String?
	let isAnonymous: Bool

	init(user: User) {
		self.uid = user.uid
		self.email = user.email
		self.photoUrl = user.photoURL?.description
		self.isAnonymous = user.isAnonymous
	}
}

enum AuthProviderOption: String {
	case email = "password"
	case google = "google.com"
}

final class AuthenticationManager {

	static let shared = AuthenticationManager()

	private init() {}

	func getAuthenticatedUser() throws -> AuthDataResultModel {
		guard let user = Auth.auth().currentUser else {
			throw URLError(.badServerResponse)
		}

		return AuthDataResultModel(user: user)
	}

	func getProvider() throws -> [AuthProviderOption] {
		guard let providerData = Auth.auth().currentUser?.providerData else {
			throw URLError(.badServerResponse)
		}

		var providers = [AuthProviderOption]()
		for provider in providerData {
			if let option = AuthProviderOption(rawValue: provider.providerID) {
				providers.append(option)
			} else {
				assertionFailure("Provider option not found: \(provider.providerID)")
			}
		}

		return providers
	}

	func signOut() throws {
		try Auth.auth().signOut()
	}

	func delete() async throws {
		guard let user = Auth.auth().currentUser else {
			throw URLError(.badURL)
		}

		try await user.delete()
	}
}

// MARK: - SIGN IN EMAIL

extension AuthenticationManager {

	@discardableResult
	func createUser(email: String, password: String) async throws -> AuthDataResultModel {
		let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
		return AuthDataResultModel(user: authDataResult.user)
	}

	@discardableResult
	func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
		let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
		return AuthDataResultModel(user: authDataResult.user)
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
}

// MARK: - SIGN IN SSO

extension AuthenticationManager {

	@discardableResult
	func signInWithGoogle(tokens: GoogleSignResultModel) async throws -> AuthDataResultModel {
		let credentials = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
		return try await signIn(credentials: credentials)
	}

	func signIn(credentials: AuthCredential) async throws -> AuthDataResultModel {
		let authDataResult = try await Auth.auth().signIn(with: credentials)
		return AuthDataResultModel(user: authDataResult.user)
	}
}

// MARK: - SIGN IN ANONYMOUS

extension AuthenticationManager {

	@discardableResult
	func signInAnonymous() async throws -> AuthDataResultModel {
		let authDataResult = try await Auth.auth().signInAnonymously()
		return AuthDataResultModel(user: authDataResult.user)
	}

	func linkEmail(email: String, password: String) async throws -> AuthDataResultModel {
		let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
		return try await linkCredential(credentials: credentials)
	}

	func linkGoogle(tokens: GoogleSignResultModel) async throws -> AuthDataResultModel {
		let credentials = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
		return try await linkCredential(credentials: credentials)
	}

	private func linkCredential(credentials: AuthCredential) async throws -> AuthDataResultModel {
		guard let user = Auth.auth().currentUser else {
			throw URLError(.badURL)
		}

		let authDataResult = try await user.link(with: credentials)
		return AuthDataResultModel(user: authDataResult.user)
	}
}
