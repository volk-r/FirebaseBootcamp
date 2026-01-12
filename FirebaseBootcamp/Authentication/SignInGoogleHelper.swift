//
//  SignInGoogleHelper.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 12.01.2026.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignResultModel {
	let idToken: String
	let accessToken: String
	let name: String?
	let email: String?
}

final class SignInGoogleHelper {

	@MainActor
	func signIn() async throws -> GoogleSignResultModel {
		guard let topVC = Utilities.shared.topViewController() else {
			throw URLError(.cannotFindHost)
		}

		let gidSignInResults = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

		guard let idToken: String = gidSignInResults.user.idToken?.tokenString else {
			throw URLError(.badServerResponse)
		}

		let accessToken: String = gidSignInResults.user.accessToken.tokenString
		let name = gidSignInResults.user.profile?.name
		let email = gidSignInResults.user.profile?.email

		let tokens = GoogleSignResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
		return tokens
	}
}
