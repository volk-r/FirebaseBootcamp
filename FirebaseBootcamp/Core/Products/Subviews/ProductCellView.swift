//
//  ProductCellView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 20.03.2026.
//

import SwiftUI

struct ProductCellView: View {

	let product: Product

    var body: some View {
		HStack(alignment: .top, spacing: 12) {
			AsyncImage(
				url: URL(string: product.thumbnail ?? "")) { image in
					image
						.resizable()
						.scaledToFit()
						.frame(width: 75, height: 75)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				} placeholder: {
					ProgressView()
				}
				.frame(width: 75, height: 75)
				.shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

			VStack(alignment: .leading, spacing: 4) {
				Text(product.title ?? "n/a")
					.font(.headline)
					.foregroundStyle(.primary)
				VStack(alignment: .leading) {
					Text("Price: $" + String(product.price ?? 0))
					Text("Ratings: " + String(product.rating ?? 0))
					Text("Category: " + (product.category ?? "n/a"))
					Text("Brand: " + (product.brand ?? "n/a"))
				}
				.font(.callout)
				.foregroundStyle(.secondary)
			}
		}
    }
}

#Preview {
	ProductCellView(product: ProductDatabase.products[0])
}
