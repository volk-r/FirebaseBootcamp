//
//  AnalyticsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 26.03.2026.
//

import SwiftUI
import FirebaseAnalytics

struct AnalyticsView: View {
    var body: some View {
		VStack(spacing: 40) {
			Button("Click me!") {
				AnalyticsManager.shared.logEvent(name: "AnalyticsView_ButtonClicked")
			}

			Button("Click me too!") {
				AnalyticsManager.shared.logEvent(name: "AnalyticsView_SecondaryButtonClicked", params: [
					"screen_title": "Hello, world!"
				])
			}
		}
		.analyticsScreen(name: "AnalyticsView")
		.onAppear {
			AnalyticsManager.shared.logEvent(name: "AnalyticsView_Appear")
		}
		.onDisappear {
			AnalyticsManager.shared.logEvent(name: "AnalyticsView_Disappear")

			AnalyticsManager.shared.setUserId(userId: "ABCD123")
			AnalyticsManager.shared.setUserProperty(value: true.description, property: "user_is_premium")
		}
    }
}

#Preview {
    AnalyticsView()
}
