//
//  FileManager+Extension.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/15/21.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    static func pathToDocumentsDirectory(with filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
