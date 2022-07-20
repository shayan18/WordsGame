//
//  GameViewNavigator.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import UIKit

final class GameViewNavigator {
    private weak var viewController: UIViewController!

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

  func dismiss() {
      viewController.dismiss(animated: true, completion: nil)
  }
}
