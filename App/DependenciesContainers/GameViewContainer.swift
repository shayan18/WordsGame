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

  func makeHomeFlowCoordinator(window: UIWindow) -> HomeNavigator { HomeNavigator(window: window, dependencies: self)
  }
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
    let actions = GameViewModelActions(dismiss: navigator.dismiss)
    let viewModel = GameViewModel(useCase: useCase, actions: actions)
    gameViewController.viewModel = viewModel
    gameViewController.modalPresentationStyle = .fullScreen
    return gameViewController
  }
}
