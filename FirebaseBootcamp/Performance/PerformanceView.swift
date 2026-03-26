//
//  PerformanceView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 26.03.2026.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {

	@State private var title: String = "Some title"

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			.onAppear {
				configure()
				downloadProductsAndUploadToFirebase()
				PerformanceManager.shared.startTrace(name: "performance_screen_time")
			}
			.onDisappear {
				PerformanceManager.shared.stopTrace(name: "performance_screen_time")
			}
    }

	private func configure() {
		let traceName = "performance_view_loading"
		PerformanceManager.shared.startTrace(name: traceName)
		PerformanceManager.shared.setValue(name: traceName, value: title, forAttribute: "title_text")

		Task {
			try? await Task.sleep(nanoseconds: 2_000_000_000)
			let forAttribute = "func_state"
			PerformanceManager.shared.setValue(name: traceName, value: "Started downloading", forAttribute: forAttribute)
			try? await Task.sleep(nanoseconds: 2_000_000_000)
			PerformanceManager.shared.setValue(name: traceName, value: "Continued downloading", forAttribute: forAttribute)
			try? await Task.sleep(nanoseconds: 2_000_000_000)
			PerformanceManager.shared.setValue(name: traceName, value: "Finished downloading", forAttribute: forAttribute)
			try? await Task.sleep(nanoseconds: 2_000_000_000)

			PerformanceManager.shared.stopTrace(name: traceName)
		}
	}

	func downloadProductsAndUploadToFirebase() {
		guard
			let url = URL(string: "https://dummyjson.com/products"),
			let metric = HTTPMetric(url: url, httpMethod: .get)
		else { return }
		metric.start()

		Task {
			do {
				let (_, response) = try await URLSession.shared.data(from: url)
				if let response = response as? HTTPURLResponse {
					metric.responseCode = response.statusCode
				}
				metric.stop()
				print("SUCCESS")
			} catch {
				print(error)
				metric.stop()
			}
		}
	}
}

#Preview {
    PerformanceView()
}
