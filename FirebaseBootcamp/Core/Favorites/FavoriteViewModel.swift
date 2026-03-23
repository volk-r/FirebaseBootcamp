//
//  FavoriteViewModel.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 23.03.2026.
//

import Combine
import Foundation

@MainActor @Observable
final class FavoriteViewModel {

	private(set) var userFavoriteProducts: [UserFavoriteProduct] = []

	private var cancellables: Set<AnyCancellable> = []

	func addListenerForFavorites() {
		guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }

//		UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
//			self?.userFavoriteProducts = products
//		}

		UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
			.sink { completion in

			} receiveValue: { [weak self] products in
				self?.userFavoriteProducts = products
			}
			.store(in: &cancellables)
	}

//	func getFavorites() {
//		Task {
//			let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//			userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//		}
//	}

	func removeFromFavorite(favoriteProductId: String) {
		Task {
			let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
			try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
//			getFavorites()
		}
	}
}
