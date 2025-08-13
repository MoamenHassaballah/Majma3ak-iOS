//
//  UIApplicationEx.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 08/08/2025.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
