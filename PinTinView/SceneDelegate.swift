//
//  SceneDelegate.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 13.07.2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // let contentView = PasswordView(mode: .checkPassword(.init(codeToCheck: "1234")), isLoading: true)
        let contentView = PasswordView(mode: .writePassword(.init()), isLoading: true)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
