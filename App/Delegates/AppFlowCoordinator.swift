//
//  AppFlowCoordinator.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import UIKit

final class AppFlowCoordinator {
  private let window: UIWindow
  private let appContainer: AppContainer

  init(window: UIWindow, appContainer: AppContainer) {
    self.window = window
    self.appContainer = appContainer
  }

  func start() {
    let gameViewContainer = appContainer.makeGameViewContainer()
    let homeFlowCoordinator = gameViewContainer.makeHomeFlowCoordinator(window: window)
    homeFlowCoordinator.start()
  }
}
