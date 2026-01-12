//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor @Observable
final class AuthenticationViewModel {

	func signInGoogle() async throws {
		let helper = SignInGoogleHelper()
		let tokens = try await helper.signIn()
		try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
	}
}

struct AuthenticationView: View {

	@State private var viewModel = AuthenticationViewModel()
	@Binding var showSignInView: Bool

    var body: some View {
		VStack {
			NavigationLink{
				SignInEmailView(showSignInView: $showSignInView)
			} label: {
				Text("Sign In With Email")
					.font(.headline)
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.frame(maxHeight: 55)
					.background(.blue)
					.clipShape(RoundedRectangle(cornerRadius: 10))
			}

			GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
				Task {
					do {
						try await viewModel.signInGoogle()
						showSignInView = false
					} catch {
						print(error)
					}
				}
			}

			Spacer()
		}
		.padding()
		.navigationTitle("Sign In")
    }
}

#Preview {
	NavigationStack {
		AuthenticationView(showSignInView: .constant(false))
	}
}
