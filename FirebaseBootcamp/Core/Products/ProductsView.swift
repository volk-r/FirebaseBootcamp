//
//  ProductsView.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 20.03.2026.
//

import SwiftUI

struct ProductsView: View {

	@State private var viewModel = ProductsViewModel()

    var body: some View {
		List {
			ForEach(viewModel.products) { product in
				ProductCellView(product: product)
					.contextMenu {
						Button("Add to favorites") {
							viewModel.addUserFavoriteProduct(productId: product.id)
						}
					}

				if product == viewModel.products.last {
					ProgressView()
						.onAppear {
							viewModel.getProducts()
						}
				}
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
//			viewModel.getProductsCount()
			viewModel.getProducts()
		}
    }
}

#Preview {
	NavigationStack {
		ProductsView()
	}
}
