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
}

struct ProfileView: View {

	@State private var viewModel = ProfileViewModel()
	@Binding var showSignInView: Bool

	var body: some View {
		List {
			Text("UserID: \(viewModel.user?.userId ?? "unknown")")
			Text("Is Anonymous: \(viewModel.user?.isAnonymous?.description.capitalized ?? "unknown")")

			Button {
				viewModel.togglePremiumStatus()
			} label: {
				Text("User is premium: \((viewModel.user?.isPremium ?? false).description.capitalized)")
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
	NavigationStack {
		ProfileView(showSignInView: .constant(false))
	}
}
