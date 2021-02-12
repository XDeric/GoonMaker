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
    
    // User gets 3 lives, initialized in the GameViewController?
    var livesRemaining: Int
    
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
        self.livesRemaining = dictionary["livesRemaining"] as? Int ?? -1
    }
}
