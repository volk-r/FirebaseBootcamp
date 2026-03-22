//
//  FavoriteView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 22.03.2026.
//

import SwiftUI

@MainActor @Observable
final class FavoriteViewModel {

	private(set) var userFavoriteProducts: [UserFavoriteProduct] = []

	func getFavorites() {
		Task {
			let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
			userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
		}
	}

	func removeFromFavorite(favoriteProductId: String) {
		Task {
			let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
			try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
			getFavorites()
		}
	}
}

struct FavoriteView: View {

	@State private var viewModel = FavoriteViewModel()

    var body: some View {
		List {
			ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
				ProductCellViewBuilder(productId: item.productId.description)
					.contextMenu {
						Button("Remove from favorites") {
							viewModel.removeFromFavorite(favoriteProductId: item.id)
						}
					}
			}
		}
		.navigationTitle("Favorites")
		.onAppear {
			viewModel.getFavorites()
		}
    }
}

#Preview {
	NavigationStack {
		FavoriteView()
	}
}
