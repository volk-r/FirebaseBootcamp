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

//	private func getAllProducts() async throws -> [Product] {
//		try await productCollection.getDocuments(as: Product.self)
//	}
//
//	private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
//		try await productCollection
//			.order(by: Product.CodingKeys.price.rawValue, descending: descending)
//			.getDocuments(as: Product.self)
//	}
//
//	private func getAllProductsFor(category: String) async throws -> [Product] {
//		try await productCollection
//			.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//			.getDocuments(as: Product.self)
//	}
//
//	private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
//		try await productCollection
//			.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//			.order(by: Product.CodingKeys.price.rawValue, descending: descending)
//			.getDocuments(as: Product.self)
//	}

	private func getAllProductsQuery() -> Query {
		productCollection
	}

	private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query {
		productCollection
			.order(by: Product.CodingKeys.price.rawValue, descending: descending)
	}

	private func getAllProductsForQuery(category: String) -> Query {
		productCollection
			.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
	}

	private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
		productCollection
			.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
			.order(by: Product.CodingKeys.price.rawValue, descending: descending)
	}

	func getAllProducts(
		priceDescending descending: Bool?,
		forCategory category: String?,
		count: Int,
		lastDocument: DocumentSnapshot?
	) async throws -> (
		products: [Product],
		lastDocument: DocumentSnapshot?
	) {
		var query: Query = getAllProductsQuery()

		if let descending, let category {
			query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
		} else if let descending {
			query = getAllProductsSortedByPriceQuery(descending: descending)
		} else if let category {
			query = getAllProductsForQuery(category: category)
		}

		return try await query
//			.limit(to: count)
			.startOptionally(afterDocument: lastDocument)
			.getDocumentsWithSnapshot(as: Product.self)
	}

	func getProductByRating(count: Int, lastRating: Double?) async throws -> [Product] {
		try await productCollection
			.order(by: Product.CodingKeys.rating.rawValue, descending: true)
			.limit(to: count)
			.start(after: [lastRating ?? 9999999999])
			.getDocuments(as: Product.self)
	}

	func getProductByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
		if let lastDocument {
			return try await productCollection
				.order(by: Product.CodingKeys.rating.rawValue, descending: true)
				.limit(to: count)
				.start(afterDocument: lastDocument)
				.getDocumentsWithSnapshot(as: Product.self)
		}

		return try await productCollection
			.order(by: Product.CodingKeys.rating.rawValue, descending: true)
			.limit(to: count)
			.getDocumentsWithSnapshot(as: Product.self)
	}

	func getAllProductsCount() async throws -> Int {
		try await productCollection
			.aggregateCount()
	}
}
