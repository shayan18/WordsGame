//
//  SceneDelegate.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  let appContainer = AppContainer()
  var appFlowCoordinator: AppFlowCoordinator?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    appFlowCoordinator = AppFlowCoordinator(window: window!, appContainer: appContainer)
    appFlowCoordinator?.start()
  }
}

