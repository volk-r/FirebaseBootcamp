//
//  CrashView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 25.03.2026.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
		ZStack {
			Color.gray.opacity(0.3).ignoresSafeArea()

			VStack(spacing: 40) {
				Button("Click me 1") {
					CrashManager.shared.addLog(message: "button_1_clicked")
					let myString: String? = nil

					guard let myString else {
						print("send sendNonFatal")
						CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
						return
					}

					let string2 = myString
				}

				Button("Click me 2") {
					CrashManager.shared.addLog(message: "button_2_clicked")
					fatalError("This was a fatal crash.")
				}

				Button("Click me 3") {
					CrashManager.shared.addLog(message: "button_3_clicked")
					let array: [String] = []
					let item = array[0]
				}
			}
		}
		.onAppear {
			CrashManager.shared.setUserId(userId: "ABC12345")
			CrashManager.shared.setIsPremiumValue(isPremium: true)
			CrashManager.shared.addLog(message: "screen is onAppearance")
			CrashManager.shared.addLog(message: "screen bla bla")
		}
    }
}

#Preview {
    CrashView()
}
