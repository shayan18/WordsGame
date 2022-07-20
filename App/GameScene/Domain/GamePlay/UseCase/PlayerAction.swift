//
//  UserAction.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import Foundation

enum PlayerAction {
  case correct(answer: String)
  case wrong(answer: String)
  case none(translation: String)
}
