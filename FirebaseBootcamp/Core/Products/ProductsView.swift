//
//  ProductsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 20.03.2026.
//

import SwiftUI

@MainActor @Observable
final class ProductsViewModel {

	private(set) var products: [Product] = []

	func getAllProducts() async throws {
		products = try await ProductsManager.shared.getAllProducts()
	}
}

struct ProductsView: View {

	@State private var viewModel = ProductsViewModel()

    var body: some View {
		List {
			ForEach(viewModel.products) { product in
				ProductCellView(product: product)
			}
		}
		.navigationTitle("Products")
		.task {
			try? await viewModel.getAllProducts()
		}
    }
}

#Preview {
	NavigationStack {
		ProductsView()
	}
}
