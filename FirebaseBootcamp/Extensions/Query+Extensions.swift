//
//  Query+Extensions.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 23.03.2026.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseSharedSwift

extension Query {

//	func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
//		let snapshot = try await self.getDocuments()
//
//		return try snapshot.documents.map { document in
//			try document.data(as: T.self)
//		}
//	}

	func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
		try await getDocumentsWithSnapshot(as: type).products
	}

	func getDocumentsWithSnapshot<T: Decodable>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) {
		let snapshot = try await self.getDocuments()

		let products = try snapshot.documents.map { document in
			try document.data(as: T.self)
		}

		return (products, snapshot.documents.last)
	}

	func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
		guard let lastDocument else { return self }
		return self.start(afterDocument: lastDocument)
	}

	func aggregateCount() async throws -> Int {
		let snapshot = try await self.count.getAggregation(source: .server)
		return Int(truncating: snapshot.count)
	}

	func addSnapshotListener<T: Decodable>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) {
		let publisher = PassthroughSubject<[T], Error>()

		let listener = self.addSnapshotListener { querySnapshot, error in
			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}

			let products: [T] = documents.compactMap { try? $0.data(as: T.self) }
			publisher.send(products)
		}

		return (publisher.eraseToAnyPublisher(), listener)
	}
}
