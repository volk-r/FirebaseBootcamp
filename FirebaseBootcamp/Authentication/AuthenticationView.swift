//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

struct AuthenticationView: View {

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
