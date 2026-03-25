//
//  CrashView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 25.03.2026.
//

import SwiftUI

import FirebaseCrashlytics

final class CrashManager {

	static let shared = CrashManager()

	private init() {}

	func setUserId(userId: String) {
		Crashlytics.crashlytics().setUserID(userId)
	}

	private func setValue(value: String, key: String) {
		Crashlytics.crashlytics().setCustomValue(value, forKey: key)
	}

	func setIsPremiumValue(isPremium: Bool) {
		setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
	}

	func addLog(message: String) {
		Crashlytics.crashlytics().log(message)
	}

	func sendNonFatal(error: Error) {
		Crashlytics.crashlytics().record(error: error)
	}
}

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
