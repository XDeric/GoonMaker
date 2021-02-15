//
//  PersistenceHelper.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/15/21.
//

import Foundation

enum DataPersistenceError: Error {
    case savingError(Error)
    case fileDoesNotExist(String)
    case noData
    case decodeError(Error)
    case deletingError(Error)
}

class PersistenceHelper {
    
}
