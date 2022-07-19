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
    let storyboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: .main)
    let gameViewController: GameViewController = GameViewController.instantiateViewController(with: storyboard)
    let repository = WordsRepository(resourceName: FileName.words.rawValue, bundle: .main)
    let useCase = GameUseCase(wordsRepository: repository)
    let navigator = GameViewNavigator(viewController: gameViewController)
    let actions = GameScreenActions(dismiss: navigator.dismiss)
    let viewModel = GameScreenViewModel(useCase: useCase, actions: actions)
    gameViewController.viewModel = viewModel
    gameViewController.modalPresentationStyle = .fullScreen
    return gameViewController
  }

}

extension UIViewController {
  static func instantiateViewController<T: UIViewController>(with storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)) -> T {
    let viewController: T = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    return viewController
  }
}
