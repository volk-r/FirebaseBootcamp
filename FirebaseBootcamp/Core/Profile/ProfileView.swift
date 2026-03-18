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
}

struct ProfileView: View {

	@State private var viewModel = ProfileViewModel()
	@Binding var showSignInView: Bool

	var body: some View {
		List {
			Text("UserID: \(viewModel.user?.userId ?? "unknown")")
			Text("Is Anonymous: \(viewModel.user?.isAnonymous?.description.capitalized ?? "unknown")")
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
