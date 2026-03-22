//
//  RootView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 10.01.2026.
//

import SwiftUI

struct RootView: View {

	@State private var showSignInView: Bool = false

    var body: some View {
		ZStack {
			if !showSignInView {
				TabbarView(showSignInView: $showSignInView)
			}
		}
		.onAppear {
			let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
			showSignInView = authUser == nil ? true : false
		}
		.fullScreenCover(isPresented: $showSignInView) {
			NavigationStack {
				AuthenticationView(showSignInView: $showSignInView)
			}
		}
    }
}

#Preview {
    RootView()
}
