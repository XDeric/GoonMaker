//
//  GameSessionModel.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/12/21.
//

import Foundation


struct GameSession: Codable & Equatable {
    // Equatable
    static func == (lhs: GameSession, rhs: GameSession) -> Bool {
        return lhs.score > rhs.score
    }
    
    // This will keep track of the game, and perform functions depending on its status?
    var gameHasStarted: Bool
    
    // NSUserDefaults should contain the name, if none is set,
    // we can prompt the user to go to settings, or provide dialog box?
    var userName: String
    
    // The actual users score to upload to firebase
    var score: Int

}
// Extension
extension GameSession {
     init(_ dictionary: [String: Any]) {
        self.userName = dictionary["userName"] as? String ?? "No User Name"
        self.score = dictionary["score"] as? Int ?? -1
    }
}
