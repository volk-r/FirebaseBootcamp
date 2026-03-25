//
//  OnFirstViewAppearModifier.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 23.03.2026.
//

import SwiftUI

struct OnFirstViewAppearModifier: ViewModifier {

	@State private var didAppear: Bool = false
	let perform: (() -> Void)?

	func body(content: Content) -> some View {
		content
			.onAppear {
				if !didAppear {
					perform?()
					didAppear = true
				}
			}
	}
}

extension View {

	func onFirstViewAppear(perform: (() -> Void)?) -> some View {
		modifier(OnFirstViewAppearModifier(perform: perform))
	}
}
