//
//  FirebaseBootcampApp.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 09.01.2026.
//

import SwiftUI
import Firebase

@main
struct FirebaseBootcampApp: App {
	// register app delegate for Firebase setup
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}

class AppDelegate: NSObject, UIApplicationDelegate {

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		FirebaseApp.configure()

		return true
	}
}
