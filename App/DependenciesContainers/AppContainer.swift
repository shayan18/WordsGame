//
//  AppContainer.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import Foundation

final class AppContainer {
    func makeGameViewContainer() -> GameViewContainer {
      let dependencies = GameViewContainer.Dependencies(FileName: FileName.words, bundle: .main)
        return GameViewContainer(dependencies: dependencies)
    }
}
