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
    private static var userName = "AAA"
    private static let userNameFile = "userName.plist"
    
    private static func saveUserName() throws {
        let url = FileManager.pathToDocumentsDirectory(with: userNameFile)
        do {
            let data = try PropertyListEncoder().encode(userName)
            try data.write(to: url, options: .atomic)
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    public func changeUserName(name: String) throws {
        PersistenceHelper.userName = name
        do {
            try PersistenceHelper.saveUserName()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    static func loadUserName() throws -> String {
        let url = FileManager.pathToDocumentsDirectory(with: userNameFile)
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    userName = try PropertyListDecoder().decode(String.self, from: data)
                } catch {
                    throw DataPersistenceError.decodeError(error)
                }
            } else {
                throw DataPersistenceError.noData
            }
        } else {
            throw DataPersistenceError.fileDoesNotExist(userNameFile)
        }
        return userName
    }
    
}
