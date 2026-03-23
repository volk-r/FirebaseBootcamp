//
//  ProductsViewModel.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 23.03.2026.
//

import Foundation
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

	func addUserFavoriteProduct(productId: Int) {
		Task {
			let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
			try? await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
		}
	}
}
