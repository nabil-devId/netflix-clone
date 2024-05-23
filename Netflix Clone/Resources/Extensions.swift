//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Ahmad Nabil on 23/05/24.
//

import UIKit


extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
}
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
