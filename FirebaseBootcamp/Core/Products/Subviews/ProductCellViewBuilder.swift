//
//  ProductCellViewBuilder.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 22.03.2026.
//

import SwiftUI

struct ProductCellViewBuilder: View {

	let productId: String
	@State private var product: Product?

    var body: some View {
        ZStack {
			if let product {
				ProductCellView(product: product)
			}
		}
		.task {
			product = try? await ProductsManager.shared.getProduct(productId: productId)
		}
    }
}

#Preview {
	ProductCellViewBuilder(productId: "1")
}
