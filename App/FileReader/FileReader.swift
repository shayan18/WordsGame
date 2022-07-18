//
//  FileReader.swift
//  TakeAway-iOS
//
//  Created by Shayan Ali on 30.06.22.
//

import Foundation
import Logging

func FileReader<T: Decodable>(
  bundle: Bundle,
  type: T.Type,
  file: String,
  fileType: FileType = .json
) -> Result<T, FileReaderError> {

  guard let path = bundle.url(forResource: file, withExtension: fileType.rawValue) else {
    Logger.shared.error("JSONReaderError: Reading JSON data failed. File expected at: \(file)")
    return .failure(.invalidPath)
  }
  var jsonData: Data?

  do {
    jsonData = try Data(contentsOf: path)
  } catch {
    Logger.shared.error("JSONReaderError: invalid data with error: \(error)")
    return .failure(.invalidData)
  }

  do {
    let model = try JSONDecoder().decode(T.self, from: jsonData!)
    return .success(model)
  } catch {
    Logger.shared.error("JSONReaderError: parse error: \(error)")
    return .failure(.error)
  }
}
