//
//  ProductsManager.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 20.03.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseSharedSwift

final class ProductsManager {

	static let shared = ProductsManager()

	private init() {}

	private let productCollection = Firestore.firestore().collection("products")

	private func productDocument(productId: String) -> DocumentReference {
		productCollection.document(productId)
	}

	func uploadProduct(product: Product) async throws {
		try productDocument(productId: String(product.id)).setData(from: product, merge: false)
	}

	func getProduct(productId: String) async throws -> Product {
		try await productDocument(productId: productId).getDocument(as: Product.self)
	}

	private func getAllProducts() async throws -> [Product] {
		try await productCollection.getDocuments(as: Product.self)
	}

	private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
		try await productCollection
			.order(by: Product.CodingKeys.price.rawValue, descending: descending)
			.getDocuments(as: Product.self)
	}

	private func getAllProductsFor(category: String) async throws -> [Product] {
		try await productCollection
			.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
			.getDocuments(as: Product.self)
	}

	private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
		try await productCollection
			.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
			.order(by: Product.CodingKeys.price.rawValue, descending: descending)
			.getDocuments(as: Product.self)
	}

	func getAllProducts(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
		if let descending, let category {
			return try await getAllProductsByPriceAndCategory(descending: descending, category: category)
		} else if let descending {
			return try await getAllProductsSortedByPrice(descending: descending)
		} else if let category {
			return try await getAllProductsFor(category: category)
		}

		return try await getAllProducts()
	}
}

extension Query {

	func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
		let snapshot = try await self.getDocuments()

		return try snapshot.documents.map { document in
			try document.data(as: T.self)
		}
	}
}
