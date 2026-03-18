//
//  SignInEmailView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

struct SignInEmailView: View {

	@State private var viewModel = SignInEmailViewModel()
	@Binding var showSignInView: Bool

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
				Task {
					do {
						try await viewModel.signUp()
						showSignInView = false
						return
					}
					catch {
						print(error)
					}

					do {
						try await viewModel.signIn()
						showSignInView = false
						return
					}
					catch {
						print(error)
					}
				}
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
		SignInEmailView(showSignInView: .constant(false))
	}
}
