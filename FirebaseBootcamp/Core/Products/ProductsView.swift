//
//  ProductsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 20.03.2026.
//

import SwiftUI

@MainActor @Observable
final class ProductsViewModel {

	var selectedFilter: FilterOption?
	var selectedCategory: CategoryOption?

	private(set) var products: [Product] = []

//	func getAllProducts() async throws {
//		products = try await ProductsManager.shared.getAllProducts()
//	}

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
//		switch option {
//		case .noFilter:
//			products = try await ProductsManager.shared.getAllProducts()
//		case .priceHight:
//			products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
//		case .priceLow:
//			products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
//		}
		selectedFilter = option
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
		getProducts()
	}

	func getProducts() {
		Task {
			products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey)
		}
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
			viewModel.getProducts()
		}
    }
}

#Preview {
	NavigationStack {
		ProductsView()
	}
}
