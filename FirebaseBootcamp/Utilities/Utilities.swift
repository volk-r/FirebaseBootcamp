//
//  Utilities.swift
//  FirebaseBootcamp
//
//  Created by Roman Romanov on 12.01.2026.
//

import Foundation
import UIKit

final class Utilities {

	static let shared = Utilities()
	private init() {}

	@MainActor
	func topViewController(controller: UIViewController? = nil) -> UIViewController? {
		//		let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController)
		let controller = controller ?? {
			if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
			   let window = scene.windows.first(where: { $0.isKeyWindow }) {
				return window.rootViewController
			}
			return nil
		}()

		if let navigationController = controller as? UINavigationController {
			return topViewController(controller: navigationController.visibleViewController)
		}
		if let tabController = controller as? UITabBarController {
			if let selected = tabController.selectedViewController {
				return topViewController(controller: selected)
			}
		}
		if let presented = controller?.presentedViewController {
			return topViewController(controller: presented)
		}
		return controller
	}
}

