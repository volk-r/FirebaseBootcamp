//
//  ProductsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 20.03.2026.
//

import SwiftUI
import FirebaseFirestore

@MainActor @Observable
final class ProductsViewModel {

	var selectedFilter: FilterOption?
	var selectedCategory: CategoryOption?

	private(set) var products: [Product] = []

	private var lastDocument: DocumentSnapshot?

	enum FilterOption: String, CaseIterable {
		case noFilter
		case priceHight
		case priceLow

		var priceDescending: Bool? {
			switch self {
			case .noFilter: return nil
			case .priceHight: return true
			case .priceLow: return false
			}
		}
	}

	func filterSelected(option: FilterOption) async throws {
		selectedFilter = option
		products = []
		lastDocument = nil
		getProducts()
	}

	enum CategoryOption: String, CaseIterable {
		case noCategory
		case groceries
		case beauty
		case furniture

		var categoryKey: String? {
			if self == .noCategory {
				return nil
			}
			return self.rawValue
		}
	}

	func categorySelected(option: CategoryOption) async throws {
		selectedCategory = option
		products = []
		lastDocument = nil
		getProducts()
	}

	func getProducts() {
		Task {
			let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)

			products.append(contentsOf: newProducts)
			if let lastDocument {
				self.lastDocument = lastDocument
			}
		}
	}

	func getProductsCount() {
		Task {
			let count = try await ProductsManager.shared.getAllProductsCount()
			print("COUNT: \(count)")
		}
	}

//	func getProductsByRating() {
//		Task {
////			let newProducts = try await ProductsManager.shared.getProductByRating(count: 4, lastRating: products.last?.rating)
//			let (newProducts, lastDocument) = try await ProductsManager.shared.getProductByRating(count: 3, lastDocument: lastDocument)
//			products.append(contentsOf: newProducts)
//			self.lastDocument = lastDocument
//		}
//	}
}

struct ProductsView: View {

	@State private var viewModel = ProductsViewModel()

    var body: some View {
		List {
			ForEach(viewModel.products) { product in
				ProductCellView(product: product)

				if product == viewModel.products.last {
					ProgressView()
						.onAppear {
							viewModel.getProducts()
						}
				}
			}
		}
		.navigationTitle("Products")
		.toolbar{
			ToolbarItem(placement: .topBarLeading) {
				Menu("Filters: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
					ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
						Button(option.rawValue) {
							Task {
								try? await viewModel.filterSelected(option: option)
							}
						}
					}
				}
			}

			ToolbarItem(placement: .topBarTrailing) {
				Menu("Categories: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
					ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
						Button(option.rawValue) {
							Task {
								try? await viewModel.categorySelected(option: option)
							}
						}
					}
				}
			}
		}
		.onAppear {
//			viewModel.getProductsCount()
			viewModel.getProducts()
		}
    }
}

#Preview {
	NavigationStack {
		ProductsView()
	}
}
