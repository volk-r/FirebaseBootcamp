//
//  FavoriteView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 22.03.2026.
//

import SwiftUI

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
		.onFirstViewAppear {
			viewModel.addListenerForFavorites()
		}
    }
}

#Preview {
	NavigationStack {
		FavoriteView()
	}
}
