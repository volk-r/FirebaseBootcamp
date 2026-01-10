//
//  SignInEmailView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

@MainActor @Observable
final class SignInEmailViewModel {

	var email = ""
	var password = ""

	func signIn() {
		guard !email.isEmpty, !password.isEmpty else {
			print("No email or password found.")
			return
		}

		Task {
			do {
				let userData = try await AuthenticationManager.shared.createUser(email: email, password: password)
				print("Successfully signed in: \(userData)")
			}
			catch {
				print("Error signing in: \(error)")
			}
		}
	}
}

struct SignInEmailView: View {

	@State private var viewModel = SignInEmailViewModel()

	var body: some View {
		VStack {
			TextField("Email...", text: $viewModel.email)
				.padding()
				.background(.gray.opacity(0.4))
				.clipShape(RoundedRectangle(cornerRadius: 10))
			SecureField("Password...", text: $viewModel.password)
				.padding()
				.background(.gray.opacity(0.4))
				.clipShape(RoundedRectangle(cornerRadius: 10))

			Button {
				viewModel.signIn()
			} label: {
				Text("Sign In")
					.font(.headline)
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.frame(maxHeight: 55)
					.background(.blue)
					.clipShape(RoundedRectangle(cornerRadius: 10))
			}

			Spacer()
		}
		.padding()
		.navigationTitle("Sign In With Email")
	}
}

#Preview {
	NavigationStack {
		SignInEmailView()
	}
}
