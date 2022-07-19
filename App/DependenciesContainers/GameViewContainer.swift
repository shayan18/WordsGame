//
//  GameViewContainer.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import UIKit

final class GameViewContainer {
  struct Dependencies {
    let FileName: FileName
    let bundle: Bundle
  }

  private let dependencies: Dependencies

  init(
    dependencies: Dependencies
  ) {
    self.dependencies = dependencies
  }

  func makeHomeFlowCoordinator(window: UIWindow) -> HomeNavigator { HomeNavigator(window: window, dependencies: self) }
}

extension GameViewContainer: HomeFlowCoordinatorDependencies {
  func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
    let homeViewController: HomeViewController = HomeViewController.instantiateViewController(with: UIStoryboard(name: Storyboard.main.rawValue, bundle: .main))
    homeViewController.viewModel = HomeViewModel(actions: actions)
    return homeViewController
  }

  func makeGameScreenViewController() -> GameViewController {
    return GameViewController()
  }

}

extension UIViewController {
  static func instantiateViewController<T: UIViewController>(with storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)) -> T {
    let viewController: T = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    return viewController
  }
}
