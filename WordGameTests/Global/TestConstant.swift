//
//  TestConstant.swift
//  WordGameTests
//
//  Created by Shayan Ali on 20.07.22.
//

import Foundation
@testable import WordGame

struct TestConstant {
  static let testWords1 = [
    Word(word: "holidays", translation: "vacaciones"),
    Word(word: "class", translation: "curso")
  ]

  static let testWords2 = [
    Word(word: "bell", translation: "timbre"),
    Word(word: "group", translation: "grupo"),
    Word(word: "quiet", translation: "quieto"),
    Word(word: "headteacher", translation: "director del colegio")
  ]
}
