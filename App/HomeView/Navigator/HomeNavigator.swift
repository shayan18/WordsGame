//
//  HomeNavigator.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
  func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
  func makeGameScreenViewController() -> GameViewController
}

final class HomeNavigator {
  private weak var window: UIWindow!
  private let dependencies: HomeFlowCoordinatorDependencies

  init(window: UIWindow, dependencies: HomeFlowCoordinatorDependencies) {
    self.window = window
    self.dependencies = dependencies
  }

  func start() {
    let actions = HomeViewModelActions(showGameView: toGameScreen)
    let homeViewController = dependencies.makeHomeViewController(actions: actions)
    window.rootViewController = homeViewController
    window?.makeKeyAndVisible()
  }

  func toGameScreen() {
    let gameScreenVC = dependencies.makeGameScreenViewController()
    window.rootViewController?.present(gameScreenVC, animated: true, completion: nil)
  }
}
