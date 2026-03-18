//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {

	@State private var viewModel = AuthenticationViewModel()
	@Binding var showSignInView: Bool

    var body: some View {
		VStack {
			Button(action: {
				Task {
					do {
						try await viewModel.signInAnonymous()
						showSignInView = false
					} catch {
						print(error)
					}
				}
			}, label: {
				Text("Sign In Anonymously")
					.font(.headline)
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.frame(maxHeight: 55)
					.background(.orange)
					.clipShape(RoundedRectangle(cornerRadius: 10))
			})

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
