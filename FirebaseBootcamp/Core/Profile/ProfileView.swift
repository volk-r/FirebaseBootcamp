//
//  ProfileView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 18.03.2026.
//

import SwiftUI

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

struct ProfileView: View {

	@State private var viewModel = ProfileViewModel()
	@Binding var showSignInView: Bool

	let preferenceOptions: [String] = ["Sports", "Movies", "Books"]

	private func preferencesInSelected(text: String) -> Bool {
		viewModel.user?.preferences?.contains(text) == true
	}

	var body: some View {
		List {
			Text("UserID: \(viewModel.user?.userId ?? "unknown")")
			Text("Is Anonymous: \(viewModel.user?.isAnonymous?.description.capitalized ?? "unknown")")

			Button {
				viewModel.togglePremiumStatus()
			} label: {
				Text("User is premium: \((viewModel.user?.isPremium ?? false).description.capitalized)")
			}

			VStack {
				HStack {
					ForEach(preferenceOptions, id: \.self) { string in
						Button(string) {
							if preferencesInSelected(text: string) {
								viewModel.removeUserPreference(test: string)
							} else {
								viewModel.addUserPreference(test: string)
							}
						}
						.font(.headline)
						.buttonStyle(.borderedProminent)
						.tint(preferencesInSelected(text: string) ? .green : .red)
					}
				}

				Text("User preferences: \((viewModel.user?.preferences ?? []).joined(separator: ", "))")
					.frame(width: .infinity, alignment: .leading)
			}

			Button {
				if viewModel.user?.favoriteMovie == nil {
					viewModel.addFavoriteMovie()
				} else {
					viewModel.removeFavoriteMovie()
				}
			} label: {
				Text("Favorite Movie: \((viewModel.user?.favoriteMovie?.title ?? ""))")
			}
		}
		.task {
			try? await viewModel.loadCurrentUser()
		}
		.navigationTitle("Profile")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				NavigationLink {
					SettingsView(showSignInView: $showSignInView)
				} label: {
					Image(systemName: "gear")
						.font(.headline)
				}
			}
		}
	}
}

#Preview {
	RootView()
}
