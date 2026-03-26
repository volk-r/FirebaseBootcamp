//
//  ProfileViewModel.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 26.03.2026.
//

import Foundation

@MainActor @Observable
final class ProfileViewModel {

	private(set) var user: DBUser?

	func loadCurrentUser() async throws {
		let authDataResultModel = try AuthenticationManager.shared.getAuthenticatedUser()
		user = try await UserManager.shared.getUser(userId: authDataResultModel.uid)
	}

	func togglePremiumStatus() {
		guard let user else { return }
		let currentValue = user.isPremium ?? false
		Task {
			try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
			self.user = try await UserManager.shared.getUser(userId: user.userId)
		}
	}

	func addUserPreference(test: String) {
		guard let user else { return }

		Task {
			try await UserManager.shared.addUserPreferences(userId: user.userId, preference: test)
			self.user = try await UserManager.shared.getUser(userId: user.userId)
		}
	}

	func removeUserPreference(test: String) {
		guard let user else { return }

		Task {
			try await UserManager.shared.removeUserPreferences(userId: user.userId, preference: test)
			self.user = try await UserManager.shared.getUser(userId: user.userId)
		}
	}

	func addFavoriteMovie() {
		guard let user else { return }
		let movie = Movie(id: "1", title: "Avatar", isPopular: true)
		Task {
			try await UserManager.shared.addFavoriteMovie(userId: user.userId, movie: movie)
			self.user = try await UserManager.shared.getUser(userId: user.userId)
		}
	}

	func removeFavoriteMovie() {
		guard let user else { return }

		Task {
			try await UserManager.shared.removeFavoriteMovie(userId: user.userId)
			self.user = try await UserManager.shared.getUser(userId: user.userId)
		}
	}
}
